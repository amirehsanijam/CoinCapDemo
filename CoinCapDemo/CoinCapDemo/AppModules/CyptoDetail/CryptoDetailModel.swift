//
//  CryptoDetailModel.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

struct CryptoDetailRequestModel: Codable {
  var id: [Int]?
  var slug: [String]?
  var symbol: [String]?
  var aux: [String]?
}

struct CryptoDetailResponseModel: Codable {
  var id: Int?
  var name, symbol, category, datumDescription: String?
  var slug: String?
  var logo: String?
  var subreddit: String?
  var tagNames: [String]?
  var tagGroups: [String]?
  var twitterUsername: String?
  var isHidden: Int?

  enum CodingKeys: String, CodingKey {
    case id, name, symbol, category
    case datumDescription = "description"
    case slug, logo, subreddit
    case tagNames = "tag-names"
    case tagGroups = "tag-groups"
    case twitterUsername = "twitter_username"
    case isHidden = "is_hidden"
  }
}
