//
//  NotificationsView.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/6/25.
//

import SwiftUI

public struct NotificationsView: View {
    @State private var viewModel: NotificationsViewModel

    public init(viewModel: NotificationsViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.state.notifications, id: \.id) {
                    NotificationCell(notification: $0)
                }
            }
        }
        .withBackground(.gray900)
        .withNavigationBar(viewModel.coordinator, config: .title(title: "알림"))
    }
}

private struct NotificationCell: View {
    let notification: NotificationInfo
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Group {
                    Text(notification.title)
                    Spacer()
                    Text(notification.time.timeAgoDescription())
                }
                .font(.B03_M)
                .foregroundStyle(.gray200)
            }

            Text(notification.message)
                .font(.B02_M)
                .foregroundStyle(.scWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 18)
    }
}

struct NotificationInfo {
    let id: String = UUID().uuidString
    let title: String
    let time: Date
    let message: String
}
