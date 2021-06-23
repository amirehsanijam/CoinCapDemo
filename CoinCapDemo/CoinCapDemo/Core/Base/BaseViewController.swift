//
//  BaseViewController.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Resolver
import RxCocoa
import RxSwift
import UIKit

protocol BaseViewControlable: AnyObject, Coordinatable, Storyboardable {
  associatedtype State: Statable
  associatedtype ViewModel: ViewModelable

  var styledTitle: String? { get set }
  var bag: DisposeBag { get }

  func setupView()
  func setupActions()
  func setupBindings()
  func stateDidChanged(state: State)
}

class BaseViewController<State: Statable, ViewModel: ViewModelable>: UIViewController, UIGestureRecognizerDelegate {

  var coordinator: Coordinator?
  var styledTitle: String?
  private let tap = UITapGestureRecognizer()

  @Injected var viewModel: ViewModel

  let bag = DisposeBag()
  var isRootViewAbleToEndEditing = true

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    setupBindings()
    setupActions()
  }

  func setupView() {}
  func setupActions() {}
  func stateDidChanged(state: State) {}

  func setupBindings() {
    viewModel
      .state
      .observe(on: MainScheduler.instance)
      .debounce(.microseconds(5), scheduler: MainScheduler.instance)
      .subscribe(
        onNext: { state in
          guard let state = state as? State else { return }
          self.stateDidChanged(state: state)
        }
      ).disposed(by: bag)

    tap.delegate = self
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
    tap.rx.event.bind { _ in
      if self.isRootViewAbleToEndEditing {
        self.view.endEditing(true)
      }
    }.disposed(by: bag)
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view is UIButton {
      return false
    }
    return true
  }
}

extension BaseViewController: BaseViewControlable {}

enum LoadingType {
  case button(button: UIButton)
  case view
}
