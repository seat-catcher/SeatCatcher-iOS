//
//  TempCommonUI.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 3/26/25.
//

import SwiftUI
import SeatCatcherCore

struct SCNavigationBar: View {
    let coordinator: Coordinator
    let isBackButtonHidden: Bool
    let title: String?
    let withBorder: Bool

    var isEmpty: Bool { isBackButtonHidden && title == nil }

    init(
        _ coordinator: Coordinator,
        isBackButtonHidden: Bool = false,
        title: String? = nil,
        withBorder: Bool = false
    ) {
        self.coordinator = coordinator
        self.isBackButtonHidden = isBackButtonHidden
        self.title = title
        self.withBorder = withBorder
    }

    var body: some View {
        VStack(spacing: 0) {
            if !isEmpty {
                HStack {
                    if !isBackButtonHidden {
                        Button {
                            coordinator.pop()
                        } label: {
                            Image(systemName: "chevron.left")
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.gray)
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 10)
                    }
                    Spacer()
                }
                .padding(.horizontal, 18)
            }
            else { Spacer().frame(height: 44) }

            if withBorder {
                Divider()
                    .background(.gray)
                    .opacity(withBorder ? 1 : 0)
                    .frame(height: 1)
            }
        }
    }
}

