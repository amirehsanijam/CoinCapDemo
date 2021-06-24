//
//  CryptoDetailCoordinator.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Resolver
import UIKit

class CryptoDetailCoordinator: Coordinator {
  var viewController: UIViewController?
  var navigationController: UINavigationController
  var id: Int

  init(_ navigationController: UINavigationController, id: Int) {
    self.navigationController = navigationController
    self.id = id
    assembleModule()
  }

  func assembleModule() {
    Resolver.register { CryptoDetailViewModel(id: self.id) }
    viewController = CryptoDetailViewController.instantiate()
    (viewController as? CryptoDetailViewController)?.coordinator = self
  }

  func start() {
    if let viewController = viewController as? CryptoDetailViewController {
      navigationController.pushViewController(viewController, animated: true)
    }
  }
}
