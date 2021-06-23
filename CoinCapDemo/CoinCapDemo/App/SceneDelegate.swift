//
//  SceneDelegate.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var coordinator: MainCoordinator?

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      setupWindow(windowScene: windowScene)
    }
    guard let _ = (scene as? UIWindowScene) else { return }
  }
}

@available(iOS 13.0, *)
extension SceneDelegate {
  func setupWindow(windowScene: UIWindowScene) {
    window = UIWindow(windowScene: windowScene)
    coordinator = MainCoordinator(window: window!)
    coordinator?.start()
  }
}


