//
//  CryptoCurrenciesListViewModel.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import RxSwift
import RxCocoa

class CryptoCurrenciesListViewModel: BaseViewModel<DefaultViewState> {
  let dataSource = PublishSubject<[CryptoCurrenciesListResponseModel]>()
  var offset: Int = 1
  var items: [CryptoCurrenciesListResponseModel] = []

  func getData(with loadingState: DefaultViewState) {

    if offset == 0 {
      return
    }

    state.onNext(loadingState)

    var router = CryptoCurrenciesListAPIRouter()
    let request = CryptoCurrenciesListRequestModel(start: offset,
                                                   limit: 20,
                                                   convert: "USD",
                                                   sort: .marketCap,
                                                   sortDirection: .desc,
                                                   cryptoType: .all,
                                                   tag: .all)
    router.requestBody = request

    netAgent
      .request(router)
      .subscribe(
        onNext: { [weak self] cryptoCurrencies in
          guard let self = self else { return }
          self.state.onNext(.idle)
          if let cryptos = cryptoCurrencies, !cryptos.isEmpty {
            self.items.append(contentsOf: cryptos)
            self.dataSource.onNext(self.items)
            self.offset += 1
          } else {
            self.offset = 0
          }
        },
        onError: { error in
          self.state.onNext(.error(error))
        }
      ).disposed(by: bag)
  }
}
