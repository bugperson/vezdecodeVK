//
//  MenuItemCollectionViewCell.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation
import UIKit

class MenuItemCollectionViewCell: UICollectionViewCell {
  struct Configuration {
    enum ButtonState {
      case `default`(price: Price)
      case selected(quantity: String)
    }

    struct Price {
      let crossedPrice: String?
      let actualPrice: String
    }

    let button: ButtonState
    let name: String
    let description: String
    let tagImage: UIImage?
  }

  private let menuItemImageView = UIImageView(image: Images.catalogMenuItemImage)
  private let tagImageView = UIImageView()
  private let menuItemName = UILabel()
  private let menuItemTitle = UILabel()
  private let defaultAddButton = DefaultMenuItemButton()
  private let selectedAddButton = MenuItemStepper()

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .trailing
    stackView.distribution = .equalCentering
    stackView.axis = .vertical
    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = Colors.menuItemGrey
    contentView.layer.cornerRadius = 8
    configure()
  }

  private func configure() {
    contentView.addSubview(menuItemImageView)
    contentView.addSubview(stackView)
    menuItemImageView.addSubview(tagImageView)

    menuItemImageView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.size.equalTo(CGSize(width: 170, height: 170))
    }

    stackView.snp.makeConstraints { make in
      make.bottom.left.right.equalToSuperview().inset(12)
      make.top.equalTo(menuItemImageView.snp.bottom).inset(12)
    }

    tagImageView.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 24, height: 24))
      make.top.left.equalToSuperview().inset(8)
      make.right.bottom.equalToSuperview().inset(138)
    }

    stackView.addArrangedSubview(menuItemName)
    stackView.addArrangedSubview(menuItemTitle)
    stackView.addArrangedSubview(defaultAddButton)
    stackView.addArrangedSubview(selectedAddButton)

    menuItemName.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }

    menuItemTitle.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(4)
      make.top.equalTo(menuItemName.snp.bottom).inset(12)
    }

    defaultAddButton.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(menuItemTitle.snp.bottom).inset(12)
    }

    selectedAddButton.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(menuItemTitle.snp.bottom).inset(12)
    }

    menuItemName.font = UIFont(name: "SFProText-Regular", size: 15)
    menuItemTitle.font = UIFont(name: "SFProText-Regular", size: 13)

    menuItemTitle.textColor = Colors.measureGrey
  }

  public func update(
    _ configuration: Configuration,
    onPlusTapped: @escaping () -> Void,
    onMinusTapped: @escaping () -> Void,
    onAddTapped: @escaping () -> Void
  ) {
    updateButton(
      configuration.button,
      onPlusTapped: onPlusTapped,
      onMinusTapped: onMinusTapped,
      onAddTapped: onAddTapped
    )
    updateName(configuration.name)
    updateTitle(configuration.description)
    updateTagImage(configuration.tagImage)
  }

  private func updateButton(
    _ state: Configuration.ButtonState,
    onPlusTapped: @escaping () -> Void,
    onMinusTapped: @escaping () -> Void,
    onAddTapped: @escaping () -> Void
  ) {
    switch state {
    case let .default(price):
      self.selectedAddButton.isHidden = true
      self.defaultAddButton.isHidden = false
      defaultAddButton.update(
        configuration: DefaultMenuItemButton.Configuration(
          price: price,
          onTap: onAddTapped
        )
      )
    case let .selected(quantity):
      self.selectedAddButton.isHidden = false
      self.defaultAddButton.isHidden = true
      selectedAddButton.updateConfiguration(
        MenuItemStepper.Configuration(
          quantity: quantity,
          onMinusPressed: onMinusTapped,
          onPlusPressed: onPlusTapped
        )
      )
    }
  }

  private func updateName(_ name: String) {
    menuItemName.text = name
  }

  private func updateTitle(_ description: String) {
    menuItemTitle.text = description
  }

  private func updateTagImage(_ image: UIImage?) {
    guard let image = image else {
      tagImageView.isHidden = true
      return
    }

    tagImageView.isHidden = false
    tagImageView.image = image
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


