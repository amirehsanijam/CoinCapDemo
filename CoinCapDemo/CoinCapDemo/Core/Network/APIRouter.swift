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

    guard var components = URLComponents(url: baseURL.appendingPathComponent(Self.path),
                                         resolvingAgainstBaseURL: false) else {
      throw NetworkError.parsing
    }

    if let queryItems = setupRequestBody() {
      print(queryItems)
      components.queryItems = queryItems
    }

    guard let url = components.url else {
      throw NetworkError.parsing
    }

    var request = URLRequest(url: url)
    request.httpMethod = Self.method.rawValue
    request.cachePolicy = .reloadRevalidatingCacheData

    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")

    if hasToken, let apiKey = Bundle.main.infoDictionary?["apiKey"] as? String {
      request.setValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
    }

    return request
  }

  private func setupRequestBody() -> [URLQueryItem]? {
    do {
      let data = requestBody?.toJSON()
      let dict = try DictionaryEncoder().encodeOf(data)
      let params = try dict?.urlEncodedString()
      Log(logLevel: .debug).debug(String(data: requestBody?.toJSON() ?? Data(), encoding: .utf8) ?? "")

      return params

    } catch {

      print(error)
      return []
    }
  }
}

extension Encodable {
  func toJSON() -> Data? { try? JSONEncoder().encode(self) }
}

public extension Dictionary where Key == String, Value == Any {

    func urlEncodedString(base: String = "") throws -> [URLQueryItem] {
        guard self.count > 0 else { return [] } // nothing to encode

        var items: [URLQueryItem] = []

        self.forEach { (key, value) in
            //guard let v = value else { return } // skip item if no value is set
          if value is Array<Any> {
            if let arrayValue = value as? Array<Any> {
              let value = arrayValue.reduce("\(arrayValue[0])") { sum, item in
                if "\(item)" != "\(arrayValue[0])" {
                  return sum + "," + "\(item)"
                }

                return sum
              }

              var queryItem = URLQueryItem(name: key,
                                           value: String(describing: value))
              queryItem.value = queryItem.value?.removingPercentEncoding
              queryItem.value = queryItem.value?.trimmingCharacters(in: CharacterSet.init(charactersIn: "()"))
              queryItem.value = queryItem.value?.trimmingCharacters(in: .whitespacesAndNewlines)
              items.append(queryItem)
            }
          } else {
            var queryItem = URLQueryItem(name: key,
                                         value: String(describing: value))
            queryItem.value = queryItem.value?.removingPercentEncoding
            queryItem.value = queryItem.value?.trimmingCharacters(in: CharacterSet.init(charactersIn: "()"))
            queryItem.value = queryItem.value?.trimmingCharacters(in: .whitespacesAndNewlines)
            items.append(queryItem)
          }

        }

      return items
    }

}
