//
//  CatalogHaedUIView.swift
//  vezdecod
//
//  Created by Danil Dubov on 18.06.2022.
//

import UIKit
import SnapKit

final class CatalogHaedView: UIView {
  private let settingsImage = UIImageView(image: Images.settingsImage)
  private let logoImage = UIImageView(image: Images.logoImage)
  private let searchImage = UIImageView(image: Images.searchImage)

  public var onTap: (() -> Void)?
  public var onTapSearch: (() -> Void)?

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.distribution = .equalCentering
    stackView.axis = .horizontal
    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onGestureTap))
    settingsImage.addGestureRecognizer(tapGesture)
    settingsImage.isUserInteractionEnabled = true
    searchImage.isUserInteractionEnabled = true
  }

  private func configureView() {
    addSubview(stackView)

    stackView.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(20)
      make.top.equalToSuperview().inset(16)
      make.bottom.equalToSuperview()
    }

    stackView.addArrangedSubview(settingsImage)
    stackView.addArrangedSubview(logoImage)
    stackView.addArrangedSubview(searchImage)

    let tap = UITapGestureRecognizer(target: self, action: #selector(onSearchTapTap))
    searchImage.addGestureRecognizer(tap)

    settingsImage.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 20, height: 20))
    }

    logoImage.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 110, height: 44))
    }

    searchImage.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 20, height: 20))
    }
  }

  @objc
  private func onGestureTap() {
    onTap?()
  }

  @objc
  private func onSearchTapTap() {
    onTapSearch?()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
