//
//  DIAgent.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation
import Resolver

struct DIAgent {
  let defaultInjection: DefaultInjection

  init() {
    defaultInjection = DefaultInjection()
  }
}

struct DefaultInjection {

  init() {
    Resolver.register { Log(logLevel: .debug) }

    #if MockServer
    Resolver.register { MockNetworkAgent(networkDelay: 1) as NetworkAgent }
    #else
    let baseURLString = Bundle.main.infoDictionary?["baseURL"] as? String ?? ""
    Resolver.register { NetworkAgent(baseUrl: URL(string: baseURLString)) }
    #endif
  }
}
