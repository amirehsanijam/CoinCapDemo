//
//  DefaultResponseModel.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

struct DefaultResponseModel<D: Decodable>: Decodable {
  let data: D?
  let status: DefaultStatusModel?
}

struct DefaultStatusModel: Codable {
    var timestamp: String?
    var errorCode: Int?
    var errorMessage: String?
    var elapsed, creditCount: Int?

    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
    }
}

