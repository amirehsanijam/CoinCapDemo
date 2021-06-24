//
//  CryptoCurrenciesListCoordinator.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Resolver
import UIKit

class CryptoCurrenciesListCoordinator: Coordinator {
  var viewController: UIViewController?
  var navigationController: UINavigationController

  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    assembleModule()
  }

  func start() {
    if let viewController = viewController as? CryptoCurrenciesListViewController {
      navigationController.setViewControllers([viewController], animated: true)
    }
  }

  func assembleModule() {
    Resolver.register { CryptoCurrenciesListViewModel() }

    viewController = CryptoCurrenciesListViewController.instantiate()
    (viewController as? CryptoCurrenciesListViewController)?
      .coordinator = self
  }

  func navigateToDetail(id: Int) {
    let coordinator = CryptoDetailCoordinator(navigationController, id: id)
    coordinator.start()
  }
}
