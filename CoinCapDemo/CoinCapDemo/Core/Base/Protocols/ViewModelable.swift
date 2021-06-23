//
//  ViewModelable.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import RxSwift

protocol ViewModelable: AnyObject {
  associatedtype State: Statable
  var state: PublishSubject<State> { get }
}

protocol Statable {}
