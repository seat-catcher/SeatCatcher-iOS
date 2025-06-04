//
//  Seat+.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/16/25.
//

import SeatCatcherDomain
import SwiftUI

extension Seat {
    
    func image(isSelected: Bool, isBlocked: Bool, isSelecting: Bool, isMySeat: Bool) -> ImageResource {
        // 좌석 방향
        let directionPrefix = seatDirection == .top ? "seat_top" : "seat_bottom"
        
        // 잠금
        if isBlocked {
            return ImageResource(name: "\(directionPrefix)_blocked", bundle: .module)
        }
        
        // 등록/이동 중 선택한 자리인 경우
        // 등록/이동 중 아닐 때 내가 앉은 자리인 경우
        if isSelecting {
            if isSelected {
                return ImageResource(name: "\(directionPrefix)_user", bundle: .module)
            } else {
                return ImageResource(name: "\(directionPrefix)_empty", bundle: .module)
            }
        }
        
        // 내가 앉아있는 자리
        if isMySeat {
            return ImageResource(name: "\(directionPrefix)_user", bundle: .module)
        }
        
        // 빈 자리
        if occupant == nil {
            return ImageResource(name: "\(directionPrefix)_empty", bundle: .module)
        }
        
        // 하차까지 시간
        var levelSuffix: String = ""
        if let minutesLeftToGetOff = occupant?.minutesLeftToGetOff {
            switch minutesLeftToGetOff {
            case ..<11:
                levelSuffix = "_level_0"
            case 11..<21:
                levelSuffix = "_level_1"
            default:
                levelSuffix = "_level_2"
            }
        }
        
        // 선택 상태
        let selectedSuffix = isSelected ? "_selected" : ""
        return ImageResource(name: "\(directionPrefix)\(levelSuffix)\(selectedSuffix)", bundle: .module)
    }
}
