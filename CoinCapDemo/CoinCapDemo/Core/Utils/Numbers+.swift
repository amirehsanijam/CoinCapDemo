//
//  Numbers+.swift
//  CoinCapDemo
//
//  Created by Amir on 6/24/21.
//

import Foundation

extension Formatter {
  static let withSeparator: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.groupingSeparator = ","
    formatter.numberStyle = .decimal
    return formatter
  }()
}

extension Double {
  var formattedWithSeparator: String {
    return Formatter.withSeparator.string(for: self) ?? ""
  }
}

extension BinaryInteger {
  var formattedWithSeparator: String {
    return Formatter.withSeparator.string(for: self) ?? ""
  }
}
