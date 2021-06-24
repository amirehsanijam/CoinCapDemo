//
//  BaseViewController.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Resolver
import RxCocoa
import RxSwift
import SnapKit
import UIKit

protocol BaseViewControlable: AnyObject, Coordinatable, Storyboardable {
  associatedtype State: Statable
  associatedtype ViewModel: ViewModelable

  var bag: DisposeBag { get }

  func setupView()
  func setupActions()
  func setupBindings()
  func stateDidChanged(state: State)
}

class BaseViewController<State: Statable, ViewModel: ViewModelable>: UIViewController, UIGestureRecognizerDelegate {

  var coordinator: Coordinator?
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

  func loading(_ enabled: Bool) {
    if enabled {
      let indicator = UIActivityIndicatorView(style: .gray)
      indicator.hidesWhenStopped = true
      indicator.tag = 9000
      view.addSubview(indicator)
      indicator.snp.makeConstraints { make in
        make.center.equalToSuperview()
        make.width.height.equalTo(40)
      }
      indicator.startAnimating()
    } else {
      view.viewWithTag(9000)?.removeFromSuperview()
    }
  }

  func showMessage(message: String?) {
    let alert = UIAlertController()
    let action = UIAlertAction(title: message, style: .cancel) { _ in }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}

extension BaseViewController: BaseViewControlable {}
