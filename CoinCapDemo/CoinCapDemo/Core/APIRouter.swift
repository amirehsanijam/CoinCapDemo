//
//  APIRouter.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation
import RxSwift

public enum RequestType: String {
  case GET, POST
}

protocol APIRouter {

  associatedtype ResponseType: Codable

  var requestBody: Encodable? { get }
  var hasToken: Bool { get }
  static var method: RequestType { get }
  static var path: String { get }

  func generateStubResponse() -> ResponseType
}

extension APIRouter {

  var hasToken: Bool {
    true
  }

  func request(with baseURL: URL?) throws -> URLRequest {
    guard let baseURL = baseURL else {
      throw NetworkError.parsing
    }

    guard let components = URLComponents(url: baseURL.appendingPathComponent(Self.path),
                                         resolvingAgainstBaseURL: false) else {
      throw NetworkError.parsing
    }

    guard let url = components.url else {
      throw NetworkError.parsing
    }

    var request = URLRequest(url: url)
    request.httpMethod = Self.method.rawValue

    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")

    if hasToken, let apiKey: String? = UserDefaultAgent().get(forKey: .apiKey) {
      request.setValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
    }

    if let data = setupRequestBody() {
      request.httpBody = data
    }

    return request
  }

  private func setupRequestBody() -> Data? {
    let data = requestBody?.toJSON()
    Log(logLevel: .debug).debug(String(data: data ?? Data(), encoding: .utf8) ?? "")

    return data
  }
}

extension Encodable {
  func toJSON() -> Data? { try? JSONEncoder().encode(self) }
}
