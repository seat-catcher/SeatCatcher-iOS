# SeatCatcher-iOS

**SeatCatcher**는 실시간으로 열차의 빈 좌석을 추적하고, 승객 간에 좌석을 공유하거나 교환할 수 있는 iOS 플랫폼입니다.

단순한 좌석 예약 앱을 넘어, **WebSocket(STOMP)** 을 활용한 실시간 상호작용과 **크레딧 시스템**을 도입하여 사용자가 능동적으로 좌석을 확보할 수 있는 경험을 제공합니다.

## 📱 UI Preview

| 홈 (여정 시작 전) | 여정 설정 (역/노선) | 실시간 좌석 현황 |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/15756220-4f17-487f-b9da-4befffc8a0ed" width="200" /> | <img src="https://github.com/user-attachments/assets/c17156f7-df3c-4874-a1c6-76c6c72f4669" width="200" /> | <img src="https://github.com/user-attachments/assets/50efb5bc-e4e2-4090-825c-22d8350d586b" width="200" /> |


---

## 🛠 Tech Stack & Environment

- **iOS Deployment Target**: iOS 17.0+
- **Language**: Swift 6.0 (Swift 5 호환)
- **Framework**: SwiftUI, Combine
- **Architecture**: Clean Architecture + MVVM-C (Coordinator) + Modularization (SPM)
- **Networking**:
  - **REST**: Moya (Alamofire Wrapper)
  - **Socket**: SwiftStomp (WebSocket/STOMP)
- **Dependency Injection**: Pure Swift DI Container
- **Authentication**: Kakao SDK, Sign in with Apple

---

## 🚀 Key Features (Detailed)

### 1. 실시간 좌석 동기화 (Real-time Seat Sync)
- **하이브리드 통신**:
  - 앱 진입 시 `REST API`로 최신 좌석 맵(`TrainCar`)을 로드하여 정합성을 맞춥니다.
  - 이후 `WebSocket(STOMP)` 채널을 구독(`subscribe`)하여, 타 사용자의 **점유(Occupied) / 해제(Free)** 이벤트를 밀리초 단위로 수신합니다.
- **시각적 피드백**: 좌석 상태 변경 시 Lottie 애니메이션과 햅틱 피드백을 통해 직관적인 경험을 제공합니다.

### 2. 5단계 여정 프로세스 (Journey FSM)
사용자의 복잡한 이동 경로 설정을 5단계의 상태 머신(Finite State Machine)으로 관리합니다.

1.  **승차 전 (Idle)**: 최근 경로 바로가기 및 즐겨찾기 제공
2.  **역 선택 (Station Selection)**: 실시간 검색 API (`/stations`)를 통해 출발/도착역 지정
3.  **열차 선택 (Train Selection)**: 현재 운행 중인 열차 목록(`Incoming`) 조회 및 선택
4.  **좌석 선택 (Seat Selection)**: 원하는 칸(`CarCode`)과 구역 진입
5.  **여정 중 (On Journey)**: 하차 알림 및 실시간 좌석 요청 모드 활성화

### 3. 좌석 교환 및 요청 시스템 (Seat Exchange)
단순 점유를 넘어, 이미 점유된 좌석을 요청할 수 있는 **P2P 교환 로직**을 구현했습니다.

- **Request**: 빈 좌석이 없을 때, 점유자에게 크레딧을 걸고 양도 요청 (`RequestSeatUseCase`)
- **Interaction**:
  - 요청자: STOMP 채널을 통해 점유자의 **수락(Accept) / 거절(Reject)** 응답 대기
  - 점유자: 푸시 알림 또는 인앱 팝업으로 요청 수신 후 결정
- **Transaction**: 수락 시 서버에서 크레딧이 즉시 이전되고 좌석 소유권이 변경됨

### 4. 보안 및 인증 (Security & Auth)
- **토큰 관리**:
  - Access/Refresh Token을 **Keychain**에 암호화하여 저장
  - Moya `RequestInterceptor`를 구현하여 401 에러 발생 시 자동으로 토큰 재발급(Silent Refresh) 수행
- **소셜 로그인**: Kakao 및 Apple 인증을 지원하며, 회원 탈퇴 시 연동 해제 로직까지 완비

---

## 🏗 Architecture Deep Dive

프로젝트는 **"관심사의 분리"**와 **"단방향 의존성"**을 위해 4개의 계층형 모듈로 설계되었습니다.

```
App (Composition Root)
 └── Presentation (MVVM-C)
      └── Domain (Business Logic) ◀── Data (Repository Impl)
           └── Core (Shared / Store)
```

### 1. Presentation Layer (MVVM + Coordinator)
- **View**: SwiftUI로 작성된 순수 UI. 로직을 포함하지 않고 `ViewModel`의 상태(`@Published`)만 바인딩합니다.
- **Coordinator**: `NavigationStack`을 제어하는 객체입니다.
  - View는 `coordinator.push(.seatDetail)`처럼 목적지만 요청할 뿐, 화면 전환 방식이나 의존성 주입을 신경 쓰지 않습니다.
  - 이를 통해 뷰의 재사용성을 높이고, 딥링크 처리가 유연해졌습니다.

### 2. Domain Layer (Pure Swift)
- 외부 프레임워크(UIKit, Moya 등)에 의존하지 않는 순수 비즈니스 로직입니다.
- **UseCases**: `YieldMySeatUseCase`, `StartJourneyUseCase` 등 앱의 핵심 기능을 캡슐화했습니다.
- **Repository Interfaces**: 데이터 계층이 구현해야 할 규약(`Protocol`)을 정의합니다. (DIP 적용)

### 3. Data Layer (Network & Storage)
- **Moya + DTO**: API 엔드포인트(`SeatCatcherAPI`)를 Enum으로 관리하며, 응답 JSON을 도메인 Entity로 매핑(Mapper)합니다.
- **Repository Implementation**:
  - 로컬 캐시나 DB가 필요한 경우 여기서 처리하고, 최종적으로 Domain Entity를 반환합니다.
  - 예: `SeatRepositoryImpl`은 API 호출 후 결과를 반환하고, 동시에 WebSocket 구독을 트리거합니다.

### 4. Core Layer (State Management)
- **AppStore (@Observable)**:
  - 앱 전역 상태(유저 정보, 현재 여정 상태, 소켓 연결 여부)를 관리하는 **Single Source of Truth**입니다.
  - Combine `PassthroughSubject`를 내장하여, 특정 이벤트(좌석 상태 변경 등)를 View나 ViewModel이 구독할 수 있게 합니다.

---

## 📂 Project Structure

```bash
SeatCatcher-iOS/
├── SeatCatcher/                  # [App Target]
│   ├── App/                      # 앱 진입점 (@main) & 생명주기
│   ├── Coordinator/              # 최상위 AppCoordinator & Scene 빌더
│   └── DIContainer/              # 의존성 주입 컨테이너 (Assembler)
│
└── Modules/                      # [Swift Packages]
    ├── SeatCatcherDomain/        # [Domain Layer]
    │   ├── Entities/             # User, Seat, TrainCar 모델
    │   ├── UseCases/             # RequestSeat, SubscribeTrain 등 비즈니스 로직
    │   └── Repositories/         # Repository Protocols
    │
    ├── SeatCatcherData/          # [Data Layer]
    │   ├── Network/Moya/         # SeatCatcherAPI 정의 (Endpoint)
    │   ├── Repositories/         # Repository 구현체 (Network 호출)
    │   └── Services/             # WebSocket(Stomp), Keychain 서비스
    │
    ├── SeatCatcherPresentation/  # [Presentation Layer]
    │   ├── Flows/                # 화면별 View & ViewModel (Home, Onboarding...)
    │   └── Common/               # 공통 UI 컴포넌트 (Button, Alert...)
    │
    └── SeatCatcherCore/          # [Core Layer]
        ├── Store/                # AppStore (전역 상태)
        └── Coordinator/          # Coordinator Protocol 정의
```

---

## 🔧 Installation & Setup

1. **Repository Clone**
   ```bash
   git clone https://github.com/SeatCatcher/SeatCatcher-iOS.git
   cd SeatCatcher-iOS
   ```

2. **Open Project**
   - `SeatCatcher.xcodeproj` 파일을 실행합니다.
   - **주의**: SPM 패키지 페칭(Fetching)이 완료될 때까지 기다려 주세요.

3. **Environment Configuration**
   - `Configurations` 폴더 내의 `xcconfig` 또는 `Info.plist`에서 API Key 설정을 확인합니다.
   - **Kakao App Key**: `KAKAO_APP_KEY` 환경 변수가 필요합니다. (빌드 오류 시 더미 값 입력 가능)

4. **Build & Run**
   - 시뮬레이터를 선택하고 `Cmd + R`로 실행합니다.
