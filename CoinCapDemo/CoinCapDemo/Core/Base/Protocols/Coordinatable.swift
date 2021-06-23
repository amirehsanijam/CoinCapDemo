//
//  Coordinator.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }

    func start()
}

extension Coordinator {
  func backToHome() {
    navigationController.popToRootViewController(animated: true)
  }
}

protocol Coordinatable {
    var coordinator: Coordinator? { get set }
}

protocol CoordinatorModular: Coordinator {
  var viewController: UIViewController? { get set }

  func assembleModule()
}
