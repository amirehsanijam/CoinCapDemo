//
//  MockNetworkAgent.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation
import RxSwift

class MockNetworkAgent: NetworkAgent {

  var networkDelay: Int = 0

  init(networkDelay: Int?) {
    super.init(baseUrl: URL(string: "https://mock.mock/")!)

    self.networkDelay = networkDelay ?? 0
  }

  override func request<R: APIRouter>(_ router: R) -> Observable<R.ResponseType?> {

    return Observable<R.ResponseType?>.create { observer in

      let result = router.generateStubResponse()

      observer.onNext(result)
      observer.onCompleted()

      return Disposables.create()
    }.delay(RxTimeInterval.seconds(networkDelay), scheduler: MainScheduler.instance)
    .observe(on: MainScheduler.instance)
  }

  override func run<C: Codable>(_ request: URLRequest) -> Observable<C?> {
    fatalError("Mocked run")
  }
}
