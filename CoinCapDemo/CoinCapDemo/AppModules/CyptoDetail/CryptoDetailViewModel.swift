//
//  CryptoDetailViewModel.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import RxSwift
import RxCocoa

class CryptoDetailViewModel: BaseViewModel<DefaultViewState> {
  let dataSource = PublishSubject<CryptoDetailResponseModel>()
  private var id: Int

  init(id: Int) {
    self.id = id
  }

  func getData() {
    state.onNext(.loading)

    let apiRouter = CryptoDetailAPIRouter(id: id)

    netAgent.request(apiRouter)
      .subscribe(
        onNext: { item in
          self.state.onNext(.idle)
          if let detailItem = item?.values.first {
            self.dataSource.onNext(detailItem)
          }
        },
        onError: { error in
          self.state.onNext(.error(error))
        }
      ).disposed(by: bag)
  }
}
