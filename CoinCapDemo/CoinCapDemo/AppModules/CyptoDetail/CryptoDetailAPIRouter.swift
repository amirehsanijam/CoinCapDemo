//
//  CryptoDetailAPIRouter.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

struct CryptoDetailAPIRouter: APIRouter {
  typealias ResponseType = [String: CryptoDetailResponseModel]
  var requestBody: Encodable?

  static var method: RequestType = .GET
  static var path: String = "v1/cryptocurrency/info"

  init(id: Int) {
    requestBody = CryptoDetailRequestModel(id: [id],
                                           slug: nil,
                                           symbol: nil,
                                           aux: ["logo","description"])
  }

  func generateStubResponse() -> [String: CryptoDetailResponseModel] {
    ["mocked": CryptoDetailResponseModel()]
  }
}
