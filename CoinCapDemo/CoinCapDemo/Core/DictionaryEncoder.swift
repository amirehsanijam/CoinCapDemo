//
//  DictionaryEncoder.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

struct DictionaryEncoder {

  private let encoder = JSONEncoder()

   func encode<T>(_ value: T) throws -> [String: Any]? where T: Encodable {
    let data = try encoder.encode(value)
    return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
  }

  func encodeArray<T>(_ value: T) throws -> [[String: Any]]? where T: Encodable {
    let data = try encoder.encode(value)
    return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]
  }

  func encodeOf(_ data: Data?) throws -> [String: Any]? {
    return try JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String: Any]
  }
}

struct DictionaryDecoder {

  private let decoder = JSONDecoder()

  func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T: Decodable {
    let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
    return try decoder.decode(type, from: data)
  }

  func decodeToData(from dictionary: [String: Any]) throws -> Data {
    return try JSONSerialization.data(withJSONObject: dictionary, options: [])
  }

  func decodeArray<T>(_ type: T.Type, from dictionary: [[String: Any]]) throws -> T where T: Decodable {
    let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
    return try decoder.decode(type, from: data)
  }
}

/// Note: This relies on the DictionaryCoding package https://github.com/elegantchaos/DictionaryCoding
struct QueryParamEncoder {
    func encode<T: Encodable>(_ item: T) -> String {
        let encoder = DictionaryEncoder()
      guard let encoded: [String: Any] = try? encoder.encode(item) else { return "" }
        let queryParams = encodeDictionary(encoded)

        return "\(queryParams)"
    }

    private func encodeDictionary(_ dictionary: [String: Any]) -> String {
        return dictionary
            .compactMap { (key, value) -> String? in
                if value is [String: Any] {
                    if let dictionary = value as? [String: Any] {
                        return encodeDictionary(dictionary)
                    }
                } else {
                    return "\(key)=\(value)"
                }

                return nil
            }
            .joined(separator: "&")
    }
}
