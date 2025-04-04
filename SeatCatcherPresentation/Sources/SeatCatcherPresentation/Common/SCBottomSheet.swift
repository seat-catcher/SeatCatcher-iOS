//
//  SCBottomSheet.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/3/25.
//

import SwiftUI

struct ButtonConfig {
    let title: String?
    let action: (() -> Void)?
}

struct TitleConfig {
    let title: String?
    let subtitle: String?
    let isSubtitleUnderlined: Bool
    
    init(title: String? = nil, subtitle: String? = nil, isSubtitleUnderlined: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.isSubtitleUnderlined = isSubtitleUnderlined
    }
}

struct ProfileConfig {
    let name: String?
    let profileImage: ImageResource?
    let tag: String?
}

class SCBottomSheetBuilder {
    var titleConfig = TitleConfig()
    var profileConfig: ProfileConfig?
    var image: ImageResource?
    var contentView: AnyView?
    var ctaButton: ButtonConfig?
    var leftButton: ButtonConfig?
    var rightButton: ButtonConfig?
    var yesButton: ButtonConfig?
    var noButton: ButtonConfig?
    var buttonStyle: SCBottomSheetButtonStyle = .none
    
    func setTitle(_ title: String?, subtitle: String? = nil, isSubtitleUnderlined: Bool = false) -> Self {
        self.titleConfig = TitleConfig(title: title, subtitle: subtitle, isSubtitleUnderlined: isSubtitleUnderlined)
        return self
    }
    
    func setImage(_ image: ImageResource?) -> Self {
        self.image = image
        return self
    }
    
    func setCTAButton(title: String?, action: (() -> Void)?) -> Self {
        self.ctaButton = ButtonConfig(title: title, action: action)
        if let action {
            self.buttonStyle = .hasCTAEnabled
        }else {
            self.buttonStyle = .hasCTADisabled
        }
        return self
    }
    
    func setProfile(name: String, profileImage: ImageResource, tag: String) -> Self {
        self.profileConfig = ProfileConfig(name: name, profileImage: profileImage, tag: tag)
        return self
    }
    
    func setDoubleButtons(leftTitle: String?, leftAction: (() -> Void)?, rightTitle: String?, rightAction: (() -> Void)?) -> Self {
        self.leftButton = ButtonConfig(title: leftTitle, action: leftAction)
        self.rightButton = ButtonConfig(title: rightTitle, action: rightAction)
        self.buttonStyle = .hasDouble
        return self
    }
    
    func setYesNoButtons(yesTitle: String?, yesAction: (() -> Void)?, noTitle: String?, noAction: (() -> Void)?) -> Self {
        self.yesButton = ButtonConfig(title: yesTitle, action: yesAction)
        self.noButton = ButtonConfig(title: noTitle, action: noAction)
        self.buttonStyle = .hasYesOrNo
        return self
    }
    
    func setDoubleButtonContentView(_ contentView: AnyView) -> Self {
        self.contentView = contentView
        return self
    }
    
    @MainActor
    func build() -> SCBottomSheet {
        SCBottomSheet(builder: self)
    }
    
    enum SCBottomSheetButtonStyle {
        case hasDouble
        case hasCTAEnabled
        case hasCTADisabled
        case hasYesOrNo
        case none
    }
}

struct SCBottomSheet: View {
    private let titleConfig: TitleConfig?
    private let profileConfig: ProfileConfig?
    private let contentView: AnyView?
    private let image: ImageResource?
    private let ctaButton: ButtonConfig?
    private let leftButton: ButtonConfig?
    private let rightButton: ButtonConfig?
    private let yesButton: ButtonConfig?
    private let noButton: ButtonConfig?
    private let buttonStyle: SCBottomSheetBuilder.SCBottomSheetButtonStyle
    
    init(builder: SCBottomSheetBuilder) {
        self.titleConfig = builder.titleConfig
        self.profileConfig = builder.profileConfig
        self.contentView = builder.contentView
        self.image = builder.image
        self.ctaButton = builder.ctaButton
        self.leftButton = builder.leftButton
        self.rightButton = builder.rightButton
        self.yesButton = builder.yesButton
        self.noButton = builder.noButton
        self.buttonStyle = builder.buttonStyle
    }
    
    var body: some View {
        switch buttonStyle {
        case .hasCTAEnabled:
            VStack(alignment: .leading, spacing: 0) {
                titleView
                Spacer()
                HStack {
                    if let image {
                        Spacer()
                        Image(image)
                            .padding(.bottom, 61)
                        Spacer()
                    }
                }
                if let ctaButton {
                    CTAButton(title: ctaButton.title ?? "", action: ctaButton.action ?? {}, style: .bottomEnabled)
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 18)
            
        case .hasCTADisabled:
            VStack(alignment: .leading, spacing: 0) {
                titleView
                Spacer()
                HStack {
                    if let image {
                        Spacer()
                        Image(image)
                            .padding(.bottom, 61)
                        Spacer()
                    }
                }
                if let ctaButton {
                    CTAButton(title: ctaButton.title ?? "", action: ctaButton.action ?? {}, style: .bottomDisabled)
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 18)
            
        case .hasDouble:
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    if let profileConfig {
                        profileView
                    }else {
                        titleView
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 0) {
                        Button {
                            // 신고하기
                        } label: {
                            HStack(alignment: .center, spacing: 0) {
                                Image(.iconAlram)
                                Text("신고하기")
                                    .font(.C01_M)
                                    .foregroundStyle(.gray300)
                            }
                            .padding(.horizontal, 6)
                            .frame(width: 78, height: 28)
                            .background(.gray500)
                            .cornerRadius(6)
                        }
                        Spacer()
                    }
                }
                .padding(.top, 40)
                Spacer()
                if let leftButton, let rightButton {
                    HStack(spacing: 19) {
                        CTAButton(title: leftButton.title ?? "", action: leftButton.action ?? {}, style: .mainLeft)
                        CTAButton(title: rightButton.title ?? "", action: rightButton.action ?? {}, style: .mainRight)
                    }
                }
            }.padding(.horizontal, 18)
            
        case .hasYesOrNo:
            VStack(alignment: .leading, spacing: 0) {
                titleView
                .padding(.bottom, 7)
                HStack(alignment: .center) {
                    Spacer()
                    if let image { Image(image) }
                    Spacer()
                }
                .frame(maxHeight: 108)
                if let yesButton, let noButton {
                    HStack(spacing: 10) {
                        CTAButton(title: noButton.title ?? "", action: noButton.action ?? {}, style: .selectionNo)
                        CTAButton(title: yesButton.title ?? "", action: yesButton.action ?? {}, style: .selectionYes)
                    }.padding(.top, 35)
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 18)
            
        case .none:
            VStack(alignment: .leading) {
                titleView
                HStack(alignment: .center) {
                    if let image {
                        Spacer()
                        Image(image)
                        Spacer()
                    }
                }
                .padding(.bottom, 33)
            }
            .padding(.top, 40)
            .padding(.horizontal, 18)
        }
    }
    
    @ViewBuilder
    var titleView: some View {
        if let titleConfig {
            VStack(alignment: .leading, spacing: 6) {
                if let title = titleConfig.title {
                    Text(title)
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
                Spacer()
            }
            .padding(.leading, 6)
        }
    }
    
    @ViewBuilder
    var doubleButtonContentView: some View {
        if let contentView {
            VStack(alignment: .center) {
                Spacer()
                contentView
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    var profileView: some View {
        if let profileConfig,
            let profileImage = profileConfig.profileImage,
            let profileName = profileConfig.name,
            let profileTag = profileConfig.tag {
            HStack(alignment: .center) {
                Image(profileImage)
                    .resizable()
                    .frame(width: 68, height: 68)
                    .padding(.trailing, 6)
                VStack(alignment: .leading, spacing: 7) {
                    Text(profileName)
                        .font(.B03_M)
                        .foregroundStyle(.gray300)
                    Text(profileTag)
                        .font(.B03_SB)
                        .foregroundStyle(.scGreen)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(.scGreen700)
                        .cornerRadius(6)
                }
                Spacer()
            }
        }
    }
}

