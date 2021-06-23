//
//  AppDelegate.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var diAgent: DIAgent?
  var coordinator: MainCoordinator?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    setupDependencies()
    setupWindow()

    return true
  }

  func setupWindow() {
    if #available(iOS 13, *) {} else {
      window = UIWindow(frame: UIScreen.main.bounds)
      coordinator = MainCoordinator(window: window!)
      coordinator?.start()
    }
  }

  func setupDependencies() {
    diAgent = DIAgent()
  }
}

