//
//  UserDefaultAgent.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

class UserDefaultAgent {

  func deleteValue(key: UserDefaultKeys) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }

  func deleteAllValues() {
    for item in UserDefaultKeys.allCases {
      deleteValue(key: item)
    }
  }

  func save<T: Encodable>(_ value: T?, forKey key: UserDefaultKeys) {
    save(value, forKey: key.rawValue)
  }

  private func save<T: Encodable>(_ value: T?, forKey key: String) {
    if T.self == String.self {
      UserDefaults.standard.set(value as? String, forKey: key)
    } else if  T.self == Int.self {
      UserDefaults.standard.set(value as? Int, forKey: key)
    } else if T.self == Double.self {
      UserDefaults.standard.set(value as? Double, forKey: key)
    } else {
      let data = try? JSONEncoder().encode(value)
      assert(data != nil, "UserDefaultAgent Error the type could not convert to json.")
      UserDefaults.standard.set(data, forKey: key)
    }

    UserDefaults.standard.synchronize()
  }

  func get<T: Decodable>(forKey key: UserDefaultKeys) -> T? {

    let strKey = key.rawValue
    return get(forKey: strKey)
  }

  private func get<T: Decodable>(forKey key: String) -> T? {
    let userDefault =  UserDefaults.standard

    if T.self == String.self {
      return userDefault.string(forKey: key) as? T
    } else if  T.self == Int.self {
      return userDefault.integer(forKey: key) as? T
    } else if T.self == Double.self {
      return userDefault.double(forKey: key) as? T
    } else {
      if let encodedData = userDefault.data(forKey: key) {
        return try? JSONDecoder().decode(T.self, from: encodedData)
      }
    }

    return nil
  }
}

enum UserDefaultKeys: String, CaseIterable {
  case apiKey
}
