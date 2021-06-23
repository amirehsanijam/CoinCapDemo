//
//  CryptoDetailAPIRouter.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

struct CryptoDetailAPIRouter: APIRouter {
  typealias ResponseType = CryptoDetailResponseModel
  var requestBody: Encodable?

  static var method: RequestType = .POST
  static var path: String = ""

  func generateStubResponse() -> CryptoDetailResponseModel {
    CryptoDetailResponseModel()
  }
}
