//
//  CryptoCurrenciesListAPIRouter.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

struct CryptoCurrenciesListAPIRouter: APIRouter {
  typealias ResponseType = CryptoCurrenciesListResponseModel
  var requestBody: Encodable?

  static var method: RequestType = .POST
  static var path: String = ""

  func generateStubResponse() -> CryptoCurrenciesListResponseModel {
    CryptoCurrenciesListResponseModel()
  }
}
