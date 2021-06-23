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

  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    assembleModule()
  }

  func assembleModule() {
    Resolver.register { CryptoDetailViewModel() }
    viewController = CryptoDetailViewController.instantiate()
    (viewController as? CryptoDetailViewController)?.coordinator = self
  }

  func start() {
    if let viewController = viewController as? CryptoDetailViewController {
      navigationController.pushViewController(viewController, animated: true)
    }
  }
}
