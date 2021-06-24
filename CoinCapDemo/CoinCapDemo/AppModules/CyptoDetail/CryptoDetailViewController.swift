//
//  CryptoDetailViewController.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Kingfisher
import RxSwift
import RxCocoa
import UIKit

class CryptoDetailViewController: BaseViewController<DefaultViewState, CryptoDetailViewModel> {
  @IBOutlet weak private var name: UILabel!
  @IBOutlet weak private var cryptoDescription: UILabel!
  @IBOutlet weak private var logo: UIImageView!

  override func setupView() {
    super.setupView()

    logo.layer.cornerRadius = logo.frame.height / 2
  }

  override func setupBindings() {
    super.setupBindings()

    viewModel
      .dataSource
      .subscribe(
        onNext: { model in
          self.updateUI(model: model)
        }
      ).disposed(by: bag)

    viewModel.getData()
  }

  private func updateUI(model: CryptoDetailResponseModel) {
    let logoURL = URL(string: model.logo ?? "")
    logo.kf.setImage(with: logoURL)
    name.text = model.name
    cryptoDescription.text = model.datumDescription
  }

  override func stateDidChanged(state: DefaultViewState) {
    super.stateDidChanged(state: state)

    switch state {
    case .loading:
      loading(true)
    case .error(let error):
      showMessage(message: error.localizedDescription)
    case .idle:
      loading(false)
    case .success:
      loading(false)
    }
  }

  override func loading(_ enabled: Bool) {
    super.loading(enabled)

    logo.isHidden = enabled
    name.isHidden = enabled
    cryptoDescription.isHidden = enabled
  }
}
