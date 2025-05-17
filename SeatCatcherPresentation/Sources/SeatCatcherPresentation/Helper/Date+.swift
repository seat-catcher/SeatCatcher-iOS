//
//  Date+.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 5/6/25.
//

import Foundation

extension Date {
    /// 지난 시간에 대한 description입니다.
    func timeAgoDescription() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.minute, .hour, .day, .weekOfYear, .month, .year],
            from: self,
            to: Date()
        )

        if let year = components.year, year >= 1 {
            return "\(year)년 전"
        } else if let month = components.month, month >= 1 {
            return "\(month)개월 전"
        } else if let week = components.weekOfYear, week >= 1 {
            return "\(week)주 전"
        } else if let day = components.day, day >= 1 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour >= 1 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute >= 1 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }
}
