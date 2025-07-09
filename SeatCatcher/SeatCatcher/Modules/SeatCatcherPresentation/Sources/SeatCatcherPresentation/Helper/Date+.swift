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

    var amPmTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한글 오전/오후
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: self)
    }

    /// "HH:mm" 포맷 (24시간제 예: "13:11")
    var hour24Time: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    /// "h:mm" 포맷 (12시간제, 오전/오후 미표시 예: "1:11")
    var hour12Time: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h:mm"
        return formatter.string(from: self)
    }
}
