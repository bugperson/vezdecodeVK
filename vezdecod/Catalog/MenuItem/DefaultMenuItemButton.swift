//
//  DefaultMenuItemButton.swift
//  vezdecod
//
//  Created by Danil Dubov on 18.06.2022.
//

import UIKit

final class DefaultMenuItemButton: UIView {
  typealias Price = MenuItemCollectionViewCell.Configuration.Price

  struct Configuration {
    let price: Price
    let onTap: (() -> Void)?
  }

  private let priceLabel = UILabel()
  private let crossedPriceLabel = UILabel()
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.distribution = .equalCentering
    stackView.axis = .horizontal
    return stackView
  }()
  
  private var onTap: (() -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
    configureGesture()
  }

  private func configure() {
    addSubview(stackView)

    snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 144, height: 44))
    }

    stackView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.top.bottom.equalToSuperview()
    }

    stackView.addArrangedSubview(priceLabel)
    stackView.addArrangedSubview(crossedPriceLabel)

    backgroundColor = Colors.defaultwhite
    layer.cornerRadius = 8
  }

  private func configureGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onGestureTap))
    addGestureRecognizer(tapGesture)
  }

  func update(configuration: Configuration) {
    self.onTap = configuration.onTap

    guard configuration.price.crossedPrice != nil else {
      updateForOnePrice(configuration: configuration)
      return
    }

    updateForTwoPrice(configuration: configuration)
  }

  private func updateForTwoPrice(configuration: Configuration) {
    crossedPriceLabel.isHidden = false

    let crossedPrice = makeCrossedAttributes(
      NSMutableAttributedString(
        string: PriceFormatter.formatte(
          value: configuration.price.crossedPrice!,
          currency: "₽"
        )
      )
    )

    let newPrice = makeNewPriceAttributes(
      NSMutableAttributedString(
        string: PriceFormatter.formatte(
          value: configuration.price.actualPrice,
          currency: "₽"
        )
      )
    )

    priceLabel.attributedText = newPrice
    crossedPriceLabel.attributedText = crossedPrice

    priceLabel.sizeToFit()
    crossedPriceLabel.sizeToFit()
  }

  private func updateForOnePrice(configuration: Configuration) {
    crossedPriceLabel.isHidden = true
    priceLabel.text = PriceFormatter.formatte(
      value: configuration.price.actualPrice,
      currency: "₽"
    )

    priceLabel.sizeToFit()
  }

  private func makeCrossedAttributes(_ attributedText: NSMutableAttributedString) -> NSMutableAttributedString {
    attributedText.addAttributes([
                    NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.strikethroughColor: UIColor.lightGray,
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.0),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray
                    ], range: NSMakeRange(0, attributedText.length))
    return attributedText
  }

  private func makeNewPriceAttributes(_ attributedText: NSMutableAttributedString) -> NSMutableAttributedString {
    attributedText.addAttributes([
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0),
                    NSAttributedString.Key.foregroundColor: UIColor.black
                    ], range: NSMakeRange(0, attributedText.length))
    return attributedText
  }

  @objc
  private func onGestureTap() {
    onTap?()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

