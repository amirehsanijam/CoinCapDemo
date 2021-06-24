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

    if hasToken, let apiKey = Bundle.main.infoDictionary?["apiKey"] as? String {
      request.setValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
    }

    if let data = setupRequestBody() {
      request.url = URL(string: try data.urlEncodedString(base: url.absoluteString))
    }

    return request
  }

  private func setupRequestBody() -> [String: Any?]? {
    let data = requestBody?.toJSON()
    let params = try? DictionaryEncoder().encodeOf(data)
    Log(logLevel: .debug).debug(String(data: requestBody?.toJSON() ?? Data(), encoding: .utf8) ?? "")

    return params
  }
}

extension Encodable {
  func toJSON() -> Data? { try? JSONEncoder().encode(self) }
}

// MARK: - Dictionary Extension
public extension Dictionary where Key == String, Value == Any? {

    /// Encode a dictionary as url encoded string
    ///
    /// - Parameter base: base url
    /// - Returns: encoded string
    /// - Throws: throw `.dataIsNotEncodable` if data cannot be encoded
    func urlEncodedString(base: String = "") throws -> String {
        guard self.count > 0 else { return "" } // nothing to encode

        var items: [URLQueryItem] = []

        self.forEach { (key, value) in
            guard let v = value else { return } // skip item if no value is set
          items.append(URLQueryItem(name: key, value: String(describing: v)))
        }

        var urlComponents = URLComponents(string: base)!
        urlComponents.queryItems = items
        guard let encodedString = urlComponents.url else {
          throw NetworkError.parsing
        }
        return encodedString.absoluteString
    }

}
