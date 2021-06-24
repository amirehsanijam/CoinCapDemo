//
//  CryptoCurrenciesListModel.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

struct CryptoCurrenciesListRequestModel: Codable {
  var start: Int?
  var limit: Int?
  var convert: String?
  var sort: Sort?
  var sortDirection: SortDirection?
  var cryptoType: CryptoType?
  var tag: Tag?

  enum CodingKeys: String, CodingKey {
    case sortDirection = "sort_dir"
    case start, limit, convert, sort
    case cryptoType = "cryptocurrency_type"
    case tag
  }
}

enum Sort: String, Codable {
  case marketCap = "market_cap"
  case name
  case price
}

enum SortDirection: String, Codable {
  case asc = "asc"
  case desc = "desc"
}

enum CryptoType: String, Codable {
  case all
  case coins
  case token
}

enum Tag: String, Codable {
  case all
  case defi
  case filesharing
}

struct CryptoCurrenciesListResponseModel: Codable {
  var id: Int?
  var name, symbol, slug: String?
  var numMarketPairs: Int?
  var dateAdded: String?
  var tags: [String]?
  var maxSupply: Int?
  var circulatingSupply, totalSupply: Double?
  var platform: Platform?
  var cmcRank: Int?
  var lastUpdated: String?
  var quote: Quote?

  enum CodingKeys: String, CodingKey {
    case id, name, symbol, slug
    case numMarketPairs = "num_market_pairs"
    case dateAdded = "date_added"
    case tags
    case maxSupply = "max_supply"
    case circulatingSupply = "circulating_supply"
    case totalSupply = "total_supply"
    case platform
    case cmcRank = "cmc_rank"
    case lastUpdated = "last_updated"
    case quote
  }
}

// MARK: - Platform
struct Platform: Codable {
  var id: Int?
  var name, symbol, slug, tokenAddress: String?

  enum CodingKeys: String, CodingKey {
    case id, name, symbol, slug
    case tokenAddress = "token_address"
  }
}

// MARK: - Quote
struct Quote: Codable {
  var usd: Usd?

  enum CodingKeys: String, CodingKey {
    case usd = "USD"
  }
}

// MARK: - Usd
struct Usd: Codable {
  var price, volume24H, percentChange1H, percentChange24H: Double?
  var percentChange7D, percentChange30D, percentChange60D, percentChange90D: Double?
  var marketCap: Double?
  var lastUpdated: String?

  enum CodingKeys: String, CodingKey {
    case price
    case volume24H = "volume_24h"
    case percentChange1H = "percent_change_1h"
    case percentChange24H = "percent_change_24h"
    case percentChange7D = "percent_change_7d"
    case percentChange30D = "percent_change_30d"
    case percentChange60D = "percent_change_60d"
    case percentChange90D = "percent_change_90d"
    case marketCap = "market_cap"
    case lastUpdated = "last_updated"
  }
}

