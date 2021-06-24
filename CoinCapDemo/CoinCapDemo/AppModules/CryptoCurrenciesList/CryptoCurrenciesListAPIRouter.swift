//
//  CryptoCurrenciesListAPIRouter.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

struct CryptoCurrenciesListAPIRouter: APIRouter {
  typealias ResponseType = [CryptoCurrenciesListResponseModel]
  var requestBody: Encodable?

  static var method: RequestType = .GET
  static var path: String = "v1/cryptocurrency/listings/latest"

  func generateStubResponse() -> [CryptoCurrenciesListResponseModel] {
    [CryptoCurrenciesListResponseModel()]
  }
}
