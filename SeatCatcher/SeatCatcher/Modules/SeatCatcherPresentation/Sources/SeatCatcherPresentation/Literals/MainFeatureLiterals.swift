//
//  MainFeatureLiterals.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 5/20/25.
//

import Foundation
import SeatCatcherDomain

public enum MainFeatureLiterals {
    
    public enum BottomButton: String {
        case manageSeat = "내 좌석 관리하기"
        case cancelRequest = "요청 취소하기"
        case confirm = "확인"
        case goBack = "돌아가기"
        case unlockSeatInformation = "좌석정보 열람하기"
        case next = "다음"
    }
    
    public enum ManageSeatButton: String {
        case registerSeat = "앉은좌석 등록하기"
        case moveSeat = "앉은좌석 이동하기"
        case cancelSeat = "앉은좌석 취소하기"
    }
    
    static func getTitleText(seatSection: SeatSectionType, status: MainFeatureViewModel.UserStatus, isBlocked: Bool) -> (title: String, subtitle: String?) {
        switch status {
        case .seated:
            return (title: seatSection.rawValue + "에서\n앉아 있어요", subtitle: nil)
        case .standing:
            return (title: seatSection.rawValue + "에서\n원하는 좌석을 찾아보세요", subtitle: isBlocked ? "크레딧을 통해 좌석정보를 확인할 수 있어요" : "빨리 비워지는 좌석일수록 밝아져요")
        case .registering, .moving:
            return (title: seatSection.rawValue + "에서\n내가 앉은 좌석을 선택해주세요", subtitle: "허위 등록 시, 이용이 제한될 수 있습니다.")
        case .cancelling:
            return (title: "현재 좌석등록을\n정말 취소하시겠어요?", subtitle: "등록 후, 5분 내 취소 시 리워드는 회수됩니다.")
        }
    }
}

