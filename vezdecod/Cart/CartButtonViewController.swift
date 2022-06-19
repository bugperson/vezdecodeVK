//
//  CartButtonViewController.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation
import UIKit

class CartButtonView: UIView {

  static let height: CGFloat = 56
  private let button: UIView = {
    let view = UIView()
    view.backgroundColor = Colors.defaultOrange
    return view
  }()

  private let imageView = UIImageView(image: Images.cart)

  private let label: UILabel = {
      let label = UILabel()
      label.textAlignment = .center
      return label
  }()

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 10
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .equalCentering
    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureButton()
    clipsToBounds = false
    backgroundColor = .white
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = .zero
    layer.shadowRadius = 10
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update(text: String, pic: UIImage?) {
    label.text = text
    imageView.image = pic
  }

  private func configureButton() {
    addSubview(button)

    button.layer.cornerRadius = 8
    button.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(16)
      $0.top.equalToSuperview().inset(12)
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(12)
      $0.height.equalTo(44)
    }

    button.addSubview(stackView)

    stackView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(label)
  }
}
