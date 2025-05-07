//
//  GetStationsRequestDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/7/25.
//

struct GetStationsRequestDTO: RequestDTO {
    init(keyword: String, line: String, order: String = "up") {
        self.keyword = keyword
        self.line = line
        self.order = order
    }

    let keyword: String
    let line: String
    let order: String
}
