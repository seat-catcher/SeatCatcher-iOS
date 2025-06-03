//
//  StompClientService.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/3/25.
//

import Foundation
import SwiftStomp
import Combine

protocol StompClientServiceProtocol {
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
    var messagePublisher: AnyPublisher<StompTextMessageDTO, Never> { get }
    func connect()
    func disconnect()
    func subscribe(topic: String)
    func unsubscribe(topic: String)
    func send(topic: String, message: String)
}

extension StompClientService: StompClientServiceProtocol {}

/// 수신된 텍스트 메시지를 단순화한 데이터 모델
struct StompTextMessageDTO {
    let text: String // 메시지 본문
    let messageId: String // STOMP message-id 헤더
    let destination: String // STOMP destination 헤더
}

/// SwiftStomp 를 래핑한 STOMP 클라이언트 서비스
public final class StompClientService {
    /// 연결 상태 변화를 외부에 발행하는 퍼블리셔
    private(set) lazy var isConnectedPublisher: AnyPublisher<Bool, Never> = {
        connectionSubject.eraseToAnyPublisher()  // CurrentValueSubject → AnyPublisher
    }()

    /// 들어오는 텍스트 메시지를 외부에 발행하는 퍼블리셔
    private(set) lazy var messagePublisher: AnyPublisher<StompTextMessageDTO, Never> = {
        messageSubject.eraseToAnyPublisher()     // PassthroughSubject → AnyPublisher
    }()

    private let swiftStomp: SwiftStomp // 실제 WebSocket + STOMP 엔진
    private var activeTopics = Set<String>() // 현재 구독 중인 토픽 집합

    private var cancellables = Set<AnyCancellable>() // Combine 구독 해제 저장소

    private let connectionSubject = CurrentValueSubject<Bool, Never>(false) // 연결 상태를 저장·발행하는 Subject, 초기값은 false(미연결)
    private let messageSubject = PassthroughSubject<StompTextMessageDTO, Never>() // 수신 메시지를 발행하는 Subject, 초기값 없이 순수 이벤트만 발행

    public init() {
        let url = URL(string: "ws://api.dev.seatcatcher.site/seatcatcher")! // url 생성

        // connectionHeader 생성
        let accessToken = try? KeychainService.get(key: "accessToken")
        let connectionHeaders: [String: String] = ["Authorization": "Bearer \(accessToken ?? "")"]

        // SwiftStomp 인스턴스 생성 (WebSocket URL 설정)
        swiftStomp = SwiftStomp(host: url, headers: connectionHeaders, httpConnectionHeaders: connectionHeaders)

        swiftStomp.autoReconnect = true // 네트워크 연결 끊길 시 자동 재연결 활성화
        swiftStomp.enableAutoPing() // WebSocket ping(heartbeat) 자동 전송 활성화
        swiftStomp.enableLogging = true // 콘솔 로그 출력 활성화

        bindSwiftStomp() // SwiftStomp의 Publisher들을 StompClientService 내부 Publisher들에 Bind

        connect()
    }

    // MARK: - 바인딩
    private func bindSwiftStomp() {
        // 1) 연결/해제/오류 이벤트 처리
        swiftStomp.eventsUpstream
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .connected(.toStomp):
                    // STOMP 브로커에 성공적으로 CONNECT 되었을 때
                    self.connectionSubject.send(true) // 연결 상태 true 발행
                    // 네트워크 복구 후 구독이 끊겼을 수 있으므로, 이전 토픽 다시 구독
                    self.activeTopics.forEach { self.swiftStomp.subscribe(to: $0) }

                case .disconnected:
                    // STOMP 또는 WebSocket 이 끊어졌을 때
                    self.connectionSubject.send(false) // 연결 상태 false 발행

                case let .error(err):
                    // STOMP 내부 오류 발생 시 (로그 출력만)
                    print("STOMP error:", err)

                default:
                    break
                }
            }
            .store(in: &cancellables)    // 구독 보관

        // 2) 수신 메시지 이벤트 처리 (오직 텍스트 메시지만)
        swiftStomp.messagesUpstream
            .receive(on: DispatchQueue.main)
            .compactMap { msg -> StompTextMessageDTO? in
                // enum .text 케이스만 필터링
                if case let .text(text, id, dest, _) = msg {
                    return StompTextMessageDTO(text: text,
                                            messageId: id,
                                            destination: dest)
                }
                return nil
            }
            .sink { [weak self] in self?.messageSubject.send($0) } // 변환된 메시지 발행
            .store(in: &cancellables) // 구독 보관
    }

    /// WebSocket + STOMP 서버로 연결 요청
    func connect() {
        swiftStomp.autoReconnect = true // disconnect 후 connect시 자동 재연결 다시 true로 설정
        guard !swiftStomp.isConnected else { return } // 이미 연결되어 있다면 중복 연결 방지
        swiftStomp.connect(autoReconnect: true) // 내부적으로 WebSocketTask 생성 → CONNECT 프레임 전송
    }

    /// STOMP DISCONNECT 보내고 WebSocket 연결 종료
    func disconnect() {
        activeTopics.removeAll() // 네트워크 유실에 의한 disconnect가 아닐 경우, 재연결 시 이전 토픽 재구독을 막기 위해 removeAll
        swiftStomp.autoReconnect = false // 재연결되지 않도록 False로 설정
        swiftStomp.disconnect() // DISCONNECT 프레임 전송 후 소켓 종료
        connectionSubject.send(false) // 강제 연결 상태 false 발행
    }

    /// 특정 토픽(예: "/train/{trainId}") 구독 요청
    func subscribe(topic: String) {
        guard !activeTopics.contains(topic) else { return } // 중복 구독 방지
        activeTopics.insert(topic) // 구독 목록에 추가
        swiftStomp.subscribe(to: topic) // SUBSCRIBE 프레임 전송
    }

    /// 특정 토픽 구독 해제 요청
    func unsubscribe(topic: String) {
        activeTopics.remove(topic) // 구독 목록에서 제거
        swiftStomp.unsubscribe(from: topic) // UNSUBSCRIBE 프레임 전송
    }

    /// 특정 토픽으로 메시지 전송
    func send(topic: String, message: String) {
        swiftStomp.send(body: message, to: topic, receiptId: nil, headers: ["content-type": "application/json"])
    }
}
