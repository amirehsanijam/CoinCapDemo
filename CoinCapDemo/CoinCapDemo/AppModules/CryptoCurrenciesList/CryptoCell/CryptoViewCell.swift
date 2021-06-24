//
//  CryptoViewCell.swift
//  CoinCapDemo
//
//  Created by Amir on 6/24/21.
//

import UIKit

class CryptoViewCell: UITableViewCell {
  @IBOutlet weak private var name: UILabel!
  @IBOutlet weak private var marketCap: UILabel!
  @IBOutlet weak private var price: UILabel!
  @IBOutlet weak private var percent: UILabel!

  override func prepareForReuse() {
    super.prepareForReuse()

    name.text = nil
    marketCap.text = nil
    price.text = nil
    percent.text = nil
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    setupView()
  }

  private func setupView() {
    selectionStyle = .none
    name.textColor = .black
    name.lineBreakMode = .byCharWrapping
    name.textAlignment = .left
    name.font = .boldSystemFont(ofSize: 12)
    marketCap.textColor = .lightGray
    marketCap.lineBreakMode = .byCharWrapping
    marketCap.textAlignment = .left
    marketCap.font = .systemFont(ofSize: 10)
    price.textColor = .black
    price.lineBreakMode = .byCharWrapping
    price.textAlignment = .right
    price.font = .boldSystemFont(ofSize: 12)
    percent.textColor = .green
    percent.lineBreakMode = .byCharWrapping
    percent.textAlignment = .right
    percent.font = .systemFont(ofSize: 10)
  }

  func data(model: Codable) {
    guard let model = model as? CryptoCurrenciesListResponseModel else { return }

    let shrinkedMCap = shrinkAmount(amount: model.quote?.usd?.marketCap ?? 0)
    let priceNum = model.quote?.usd?.price ?? 0
    let percentNum = model.quote?.usd?.percentChange24H ?? 0
    let shrinkedPrice = Double(round(100*priceNum)/100)
    let shrinkedPercent = Double(round(100*percentNum)/100)


    percent.textColor = shrinkedPercent < 0 ? .red : .green

    name.text = (model.name ?? "") + " " + "(\(model.symbol ?? ""))"
    marketCap.text = "MCap " + shrinkedMCap.amount.formattedWithSeparator + shrinkedMCap.unit
    price.text = "$" + shrinkedPrice.formattedWithSeparator
    percent.text = String(shrinkedPercent) + "%"
  }

  func shrinkAmount(amount: Double) -> (amount: UInt64, unit: String) {
      if amount > 1_000_000_000 && amount <= 100_000_000_000 {
        return (UInt64(amount) / 1_000_000, "M")
      } else if amount > 100_000_000_000 {
        return (UInt64(amount) / 1_000_000_000, "B")
      }
      return (UInt64(amount), "")
  }
}
