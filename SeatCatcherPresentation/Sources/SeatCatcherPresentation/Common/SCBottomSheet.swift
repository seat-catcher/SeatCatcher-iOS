import SwiftUI

struct ButtonConfig {
    let title: String
    let action: () -> Void
    
    init(title: String = "", action: @escaping () -> Void = {}) {
        self.title = title
        self.action = action
    }
}

struct TitleConfig {
    let title: String
    let subtitle: String?
    let isSubtitleUnderlined: Bool
    
    init(title: String = "", subtitle: String? = nil, isSubtitleUnderlined: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.isSubtitleUnderlined = isSubtitleUnderlined
    }
}

final class SCBottomSheetBuilder {
    private var titleConfig = TitleConfig()
    private var profileConfig: ProfileConfig?
    private var image: ImageResource?
    private var contentView: AnyView?
    private var buttons: [ButtonType] = []
    private var buttonStyle: SCBottomSheetButtonStyle = .none
    
    enum ButtonType {
        case cta(ButtonConfig)
        case double(left: ButtonConfig, right: ButtonConfig)
        case yesNo(yes: ButtonConfig, no: ButtonConfig)
    }
    
    enum SCBottomSheetButtonStyle {
        case hasCTAEnabled, hasCTADisabled, hasDouble, hasYesOrNo, none
    }
    
    @discardableResult
    func withTitle(_ title: String, subtitle: String? = nil, underlined: Bool = false) -> Self {
        titleConfig = TitleConfig(title: title, subtitle: subtitle, isSubtitleUnderlined: underlined)
        return self
    }
    
    @discardableResult
    func withImage(_ image: ImageResource) -> Self {
        self.image = image
        return self
    }
    
    @discardableResult
    func withProfile(profileConfig: ProfileConfig) -> Self {
        self.profileConfig = profileConfig
        return self
    }
    
    @discardableResult
    func withCTA(title: String, action: @escaping () -> Void = {}) -> Self {
        let config = ButtonConfig(title: title, action: action)
        buttons = [.cta(config)]
        buttonStyle = action != nil ? .hasCTAEnabled : .hasCTADisabled
        return self
    }
    
    @discardableResult
    func withDoubleButtons(leftTitle: String, leftAction: @escaping () -> Void = {},
                           rightTitle: String, rightAction: @escaping () -> Void = {}) -> Self {
        let left = ButtonConfig(title: leftTitle, action: leftAction)
        let right = ButtonConfig(title: rightTitle, action: rightAction)
        buttons = [.double(left: left, right: right)]
        buttonStyle = .hasDouble
        return self
    }
    
    @discardableResult
    func withYesNoButtons(yesTitle: String, yesAction: @escaping () -> Void = {},
                          noTitle: String, noAction: @escaping () -> Void = {}) -> Self {
        let yes = ButtonConfig(title: yesTitle, action: yesAction)
        let no = ButtonConfig(title: noTitle, action: noAction)
        buttons = [.yesNo(yes: yes, no: no)]
        buttonStyle = .hasYesOrNo
        return self
    }
    
    @discardableResult
    func withContent(_ content: some View) -> Self {
        self.contentView = AnyView(content)
        return self
    }
    
    @MainActor
    func build() -> SCBottomSheet {
        SCBottomSheet(builder: self)
    }
    
    fileprivate func getConfig() -> (
        title: TitleConfig,
        profile: ProfileConfig?,
        image: ImageResource?,
        content: AnyView?,
        buttons: [ButtonType],
        buttonStyle: SCBottomSheetButtonStyle
    ) {
        (titleConfig, profileConfig, image, contentView, buttons, buttonStyle)
    }
}

struct SCBottomSheet: View {
    private let titleConfig: TitleConfig
    private let profileConfig: ProfileConfig?
    private let image: ImageResource?
    private let contentView: AnyView?
    private let buttons: [SCBottomSheetBuilder.ButtonType]
    private let buttonStyle: SCBottomSheetBuilder.SCBottomSheetButtonStyle
    
    init(builder: SCBottomSheetBuilder) {
        let config = builder.getConfig()
        self.titleConfig = config.title
        self.profileConfig = config.profile
        self.image = config.image
        self.contentView = config.content
        self.buttons = config.buttons
        self.buttonStyle = config.buttonStyle
    }
    
    var body: some View {
        switch buttonStyle {
        case .hasCTAEnabled, .hasCTADisabled:
            VStack(alignment: .leading, spacing: 0) {
                titleView
                Spacer(minLength: 0)
                if let image {
                    Image(image)
                        .padding(.bottom, 61)
                        .frame(maxWidth: .infinity)
                }
                if case .cta(let config) = buttons.first {
                    CTAButton(title: config.title, action: config.action,
                            style: buttonStyle == .hasCTAEnabled ? .bottomEnabled : .bottomDisabled)
                    .padding(.bottom, 33)
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 18)
            
        case .hasDouble:
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    if let profileConfig {
                        profileView
                    }else {
                        titleView
                    }
                    Spacer()
                    Button(action: {
                        // 신고하기
                    }) {
                        HStack(spacing: 0) {
                            Image(.iconAlarm)
                            Text("신고하기").font(.C01_M).foregroundStyle(.gray300)
                        }
                        .padding(.horizontal, 6)
                        .frame(width: 78, height: 28)
                        .background(.gray500)
                        .cornerRadius(6)
                    }
                }
                .frame(minHeight: 54, maxHeight: 68)
                .padding(.top, 40)
                HStack {
                    Spacer(minLength: 0)
                    contentView
                    Spacer(minLength: 0)
                }
                .frame(maxHeight: 132)
                Spacer(minLength: 0)
                if case .double(let left, let right) = buttons.first {
                    HStack(spacing: 19) {
                        CTAButton(title: left.title, action: left.action, style: .mainLeft)
                        CTAButton(title: right.title, action: right.action, style: .mainRight)
                    }.padding(.bottom, 33)
                }
            }
            .padding(.horizontal, 18)
            
        case .hasYesOrNo:
            VStack(alignment: .leading, spacing: 0) {
                titleView
                    .padding(.top, 40)
                Spacer(minLength: 0)
                if let image {
                    HStack {
                        Spacer()
                        Image(image)
                            .frame(maxHeight: 108)
                            .padding(.bottom, 35)
                        Spacer()
                    }
                }
                Spacer(minLength: 0)
                if case .yesNo(let yes, let no) = buttons.first {
                    HStack(spacing: 10) {
                        CTAButton(title: no.title, action: no.action, style: .selectionNo)
                        CTAButton(title: yes.title, action: yes.action, style: .selectionYes)
                    }
                    .padding(.bottom, 33)
                }
            }
            .padding(.horizontal, 18)
            
        case .none:
            VStack(alignment: .leading) {
                titleView
                    .padding(.top, 40)
                if let image {
                    HStack(alignment: .center) {
                        Spacer()
                        Image(image)
                        Spacer()
                    }
                    .frame(height: 220)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 18)
        }
    }
    
    @ViewBuilder
    var titleView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titleConfig.title)
                .font(.B01_SB)
                .foregroundStyle(.gray100)
            if let subtitle = titleConfig.subtitle {
                Text(subtitle)
                    .font(.B03_M)
                    .foregroundStyle(.gray300)
                    .underline(titleConfig.isSubtitleUnderlined)
                    .lineLimit(2)
            }
        }
        .padding(.bottom, 7)
    }
    
    @ViewBuilder
    var profileView: some View {
        if let profile = profileConfig {
            ProfileView(profile: profile)
        }
    }
}
