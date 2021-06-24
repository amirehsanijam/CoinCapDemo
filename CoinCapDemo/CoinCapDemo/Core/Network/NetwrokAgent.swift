//
//  NetwrokAgent.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Resolver
import RxSwift

class NetworkAgent {

  private let baseURL: URL?
  private var decoder: JSONDecoder!
  private var encoder: JSONEncoder!
  private var session: URLSession!

  private var log: Log!

  init(baseUrl: URL?) {
    baseURL = baseUrl
    setupURLSessionConfiguration()
    setupDecoder()
    setupEncoder()
    log = Log(logLevel: .debug)
  }

  func setupURLSessionConfiguration() {
    let config = URLSessionConfiguration.default
    config.httpShouldSetCookies = false
    config.httpCookieAcceptPolicy = .never
    config.networkServiceType = .responsiveData
    config.shouldUseExtendedBackgroundIdleMode = true
    self.session = URLSession(configuration: config, delegate: nil, delegateQueue: .main)
  }

  func setupDecoder() {
    let decoder =  JSONDecoder()
    decoder.dataDecodingStrategy = .base64
    decoder.dateDecodingStrategy = .millisecondsSince1970
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(
      positiveInfinity: "Infinity",
      negativeInfinity: "-Infinity",
      nan: "NaN")

    self.decoder = decoder
  }

  func setupEncoder() {
    let encoder = JSONEncoder()
    encoder.dataEncodingStrategy = .base64
    encoder.dateEncodingStrategy = .custom({ (date, encoder) in
      var container = encoder.singleValueContainer()
      try container.encode(Int64(date.timeIntervalSinceNow * 1000))
    })

    self.encoder = encoder
  }

  func request<R: APIRouter>(_ router: R) -> Observable<R.ResponseType?> {

    do {

      let request = try router.request(with: self.baseURL)
      log.debugNetwork(request: request)
      return run(request)
    } catch {
      return Observable<R.ResponseType?>.create { observer in
        observer.onError(error)
        return Disposables.create()
      }.observe(on: MainScheduler.instance)
    }
  }

  func run<C: Codable>(_ request: URLRequest) -> Observable<C?> {
    return Observable<C?>
      .create { observer in
        let task = self.session.dataTask(with: request) { (data, response, error) in
          do {
            self.log.debugNetwork(data: data, response: response, error: error)

            if let error = error {
              _ = try self.serverErrorHandler(error: error)
            }
            guard let response = response as? HTTPURLResponse else { throw NetworkError.noResponse }

            let model: C? = try self.validate(response: response, data: data)

            observer.onNext(model)
          } catch {
            observer.onError(error)
          }
          observer.onCompleted()
        }

        task.resume()

        return Disposables.create {
          task.cancel()
        }
      }.observe(on: MainScheduler.instance)
  }

  private func validate<C: Codable>(response: HTTPURLResponse, data: Data?) throws -> C? {

    if (500..<599).contains(response.statusCode) {
      throw NetworkError.internalServerError
    }

    guard let data = data else { throw NetworkError.invalidResponse }

    var model: DefaultResponseModel<C>

    do {
      model = try self.decoder.decode(DefaultResponseModel<C>.self, from: data)
    } catch {
      log.debug(error.localizedDescription)
      throw error
    }

    guard !(200..<399).contains(response.statusCode) else {
      return model.data
    }

    let errorDict = errorDictionary(modelMessage: model.status?.errorMessage ?? "")
    throw errorDict[Int(model.status?.errorCode ?? -1000)] ?? NetworkError.invalidResponse
  }

  func errorDictionary(modelMessage: String) -> [Int: NetworkError] {
    var dict: [Int: NetworkError] = [:]
    dict[1001] = NetworkError.apiKeyInvalid
    dict[1002] = NetworkError.apiKeyMissing
    dict[1003] = NetworkError.apiKeyPlanRequiresPayment
    dict[1004] = NetworkError.apiKeyPlanPaymentExpired
    dict[1005] = NetworkError.apiKeyRequired
    dict[1006] = NetworkError.apiKeyPlanNotAuthorized
    dict[1007] = NetworkError.apiKeyDisabled
    dict[1008] = NetworkError.apiKeyPlanMinuteRateLimitReached
    dict[1009] = NetworkError.apiKeyPlanDailyRateLimitReached
    dict[1010] = NetworkError.apiKeyPlanMonthlyRateLimitReached
    dict[1011] = NetworkError.IPRateLimitReached
    return dict
  }

  func serverErrorHandler(error: Error) throws -> NetworkError {
    guard let error = error as NSError?, error.domain == NSURLErrorDomain else {
      throw NetworkError.internalServerError
    }

    if error.code == NSURLErrorNotConnectedToInternet ||
        error.code == NSURLErrorDataNotAllowed {
      throw NetworkError.notConnectedToInternet
    } else {
      throw NetworkError.internalServerError
    }
  }
}

