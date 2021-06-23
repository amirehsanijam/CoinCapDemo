//
//  BaseViewModel.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation
import Resolver
import RxSwift

class BaseViewModel<State: Statable>: ViewModelable {

  @Injected var netAgent: NetworkAgent
  @Injected var log: Log

  let bag = DisposeBag()
  var state = PublishSubject<State>()
}

enum DefaultViewState: Statable {
  case loading
  case error(Error)
  case idle
  case success(message: String? = nil)
}
