//
//  GetIncomingsRequestDTO.swift
//  SeatCatcherData
//
//  Created by 박현수 on 5/27/25.
//

struct GetIncomingsRequestDTO: RequestDTO {
    let lineNumber: String
    let dep: String
    let dest: String
}
