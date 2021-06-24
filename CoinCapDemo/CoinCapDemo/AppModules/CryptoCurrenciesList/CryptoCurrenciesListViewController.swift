//
//  CryptoCurrenciesListViewController.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import UIKit
import RxSwift
import RxCocoa

class CryptoCurrenciesListViewController: BaseViewController<DefaultViewState, CryptoCurrenciesListViewModel> {
  @IBOutlet weak private var cryptoList: UITableView!

  let cellName = "CryptoViewCell"

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.prefersLargeTitles = true
    title = "Crypto List"
  }

  override func setupView() {
    super.setupView()

    cryptoList.allowsMultipleSelection =  false
    cryptoList.showsVerticalScrollIndicator = false
    cryptoList.allowsSelection = true
    cryptoList.rowHeight = UITableView.automaticDimension
    cryptoList.estimatedRowHeight = 80
    cryptoList.register(UINib(nibName: cellName, bundle: .main),
                        forCellReuseIdentifier: cellName)
    cryptoList.delegate = self
    cryptoList.isHidden = true
  }

  override func setupBindings() {
    super.setupBindings()

    viewModel
      .dataSource
      .bind(to: cryptoList.rx.items) { (tableView, row, element) in

        guard let cell = tableView
                .dequeueReusableCell(
                  withIdentifier: self.cellName,
                  for: IndexPath(row: row, section: 0)) as? CryptoViewCell
        else {
          return UITableViewCell()
        }

        cell.data(model: element)

        return cell

      }.disposed(by: bag)

    viewModel.getData(with: .loading)
  }

  override func setupActions() {
    super.setupActions()

    cryptoList.rx
      .modelSelected(CryptoCurrenciesListResponseModel.self)
      .bind { model in
        guard let id = model.id else { return }
        (self.coordinator as? CryptoCurrenciesListCoordinator)?.navigateToDetail(id: id)
      }.disposed(by: bag)
  }

  override func stateDidChanged(state: DefaultViewState) {
    super.stateDidChanged(state: state)

    switch state {
    case .loading:
      cryptoList.isHidden = true
      loading(true)
    case .error(let error):
      cryptoList.isHidden = false
      loading(false)
      showMessage(message: error.localizedDescription)
    case .idle:
      cryptoList.isHidden = false
      loading(false)
    case .success:
      cryptoList.isHidden = false
      loading(false)
    }
  }
}

extension CryptoCurrenciesListViewController: UITableViewDelegate {
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      if decelerate && scrollView.contentOffset.y >= 0 {
          let offsetY = scrollView.contentOffset.y + scrollView.frame.height - scrollView.contentInset.bottom
          let contetnHeight = scrollView.contentSize.height

          let reloadDistance: CGFloat = contetnHeight - scrollView.frame.height - 80

          if offsetY > reloadDistance {
            viewModel.getData(with: .idle)
          }
      }
  }
}
