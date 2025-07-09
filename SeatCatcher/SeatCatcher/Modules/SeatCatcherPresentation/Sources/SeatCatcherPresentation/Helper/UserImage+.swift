//
//  UserImage+.swift
//  SeatCatcherPresentation
//
//  Created by 박현수 on 4/11/25.
//

import SeatCatcherDomain
import SwiftUI

extension UserImage {
    var image: ImageResource {
        switch self {
        case .catchy1: .catchy1
        case .catchy2: .catchy2
        case .catchy3: .catchy3
        case .coco1: .coco1
        case .coco2: .coco2
        case .coco3: .coco3
        }
    }
}
