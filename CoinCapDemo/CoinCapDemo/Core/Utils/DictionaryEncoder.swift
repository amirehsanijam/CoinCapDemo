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
