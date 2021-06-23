//
//  MainCoordinator.swift
//  CoinCapDemo
//
//  Created by Amir on 6/24/21.
//

import UIKit
import Resolver

class MainCoordinator: NSObject {

  var window: UIWindow?
  var navigationController: UINavigationController
  var viewController: UIViewController?

  init(window: UIWindow) {

    self.navigationController = UINavigationController()
    self.window = window

    super.init()

    assembleModule()
  }

  func assembleModule() {
    Resolver.register { CryptoCurrenciesListCoordinator(self.navigationController) }.scope(.application)
  }

  func start() {
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    coordinateToFirstPage()
  }

  private func coordinateToFirstPage() {
    let coordinator = Resolver.resolve(CryptoCurrenciesListCoordinator.self)
    coordinator.start()
  }
}

