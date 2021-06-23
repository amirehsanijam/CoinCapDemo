//
//  NetworkError.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

enum NetworkError: Error {
  case parsing
  case network
  case internalServerError
  case invalidResponse
  case noResponse
  case badRequest(message: String?)
  case notConnectedToInternet
  case apiKeyInvalid
  case apiKeyMissing
  case apiKeyPlanRequiresPayment
  case apiKeyPlanPaymentExpired
  case apiKeyRequired
  case apiKeyPlanNotAuthorized
  case apiKeyDisabled
  case apiKeyPlanMinuteRateLimitReached
  case apiKeyPlanDailyRateLimitReached
  case apiKeyPlanMonthlyRateLimitReached
  case IPRateLimitReached
}

extension NetworkError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .internalServerError:
      let errorMessage = ""
      return errorMessage
    case .badRequest(let message):
      return message ?? "bad.request"
    case .notConnectedToInternet:
      return "not.connected.to.internet"
    default:
      return "something.wrong"
    }
  }
}

enum AppError: Error {
  case nilValue
  case viewError(message: String)
}

extension AppError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .nilValue:
      return "operation.failed"
    case .viewError(let message):
      return message.isEmpty ? "" : message
    }
  }
}


