//
//  FilterPopUpViewController.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import UIKit

final class FilterPopUpViewController: UIViewController {
  let checkmarkImageView1 = UIImageView(image: Images.checkmarkImage)
  let checkmarkImageView2 = UIImageView(image: Images.checkmarkImage)
  let checkmarkImageView3 = UIImageView(image: Images.checkmarkImage)

  let bottomSheetView = UIView()

  let separatorOne: UIView = {
    let view = UIView()
    view.frame.size = CGSize(width: UIScreen.main.bounds.size.width - 48, height: 1)
    view.backgroundColor = Colors.defaultBlack
    return view
  }()

  let separatorTwo: UIView = {
    let view = UIView()
    view.frame.size = CGSize(width: UIScreen.main.bounds.size.width - 48, height: 1)
    view.backgroundColor = Colors.defaultBlack
    return view
  }()

  let nameLable = UILabel()
  let veganLabel = UILabel()
  let spicyLabel = UILabel()
  let saleLabel = UILabel()

  let readyButton = UIButton()

  var zalupa: (() -> Void)?

  let veganStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.distribution = .equalCentering
    stackView.axis = .horizontal
    return stackView
  }()

  let spicyStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.distribution = .equalCentering
    stackView.axis = .horizontal
    return stackView
  }()

  let saleStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.distribution = .equalCentering
    stackView.axis = .horizontal
    return stackView
  }()

  let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 2
    stackView.alignment = .leading
    stackView.distribution = .equalSpacing
    stackView.axis = .vertical
    return stackView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }

  private func configure() {
    view.backgroundColor = .clear

    view.addSubview(bottomSheetView)
    bottomSheetView.snp.makeConstraints { make in
      make.size.width.equalTo(375)
      make.left.bottom.right.equalToSuperview()
    }
    bottomSheetView.layer.cornerRadius = 15
    bottomSheetView.backgroundColor = Colors.defaultwhite
    
    configureLabels()
    configureReadyButton()
  }

  private func configureLabels() {
    nameLable.text = "Подобрать блюда"
    nameLable.font = UIFont(name: "SFProDisplay-Bold", size: 22)

    bottomSheetView.addSubview(nameLable)

    nameLable.snp.makeConstraints { make in
      make.top.equalTo(bottomSheetView.snp.top).inset(32)
      make.right.left.equalToSuperview().inset(24)
    }

    saleLabel.text = "Со скидкой"
    saleLabel.font = UIFont(name: "SFProText-Regular", size: 17)

    spicyLabel.text = "Острые"
    spicyLabel.font = UIFont(name: "SFProText-Regular", size: 17)

    veganLabel.text = "Подобрать блюда"
    veganLabel.font = UIFont(name: "SFProText-Regular", size: 17)

    bottomSheetView.addSubview(stackView)

    stackView.snp.makeConstraints { make in
      make.top.equalTo(nameLable.snp.bottom).inset(-12)
      make.right.left.equalToSuperview().inset(24)
    }

    stackView.addArrangedSubview(spicyStackView)
    stackView.addArrangedSubview(separatorOne)
    stackView.addArrangedSubview(veganStackView)
    stackView.addArrangedSubview(separatorTwo)
    stackView.addArrangedSubview(saleStackView)

    spicyStackView.addArrangedSubview(spicyLabel)
    spicyStackView.addArrangedSubview(checkmarkImageView1)

    veganStackView.addArrangedSubview(veganLabel)
    veganStackView.addArrangedSubview(checkmarkImageView2)

    saleStackView.addArrangedSubview(saleLabel)
    saleStackView.addArrangedSubview(checkmarkImageView3)

    checkmarkImageView1.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 14, height: 14))
    }

    checkmarkImageView2.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 14, height: 14))
    }

    checkmarkImageView3.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 14, height: 14))
    }
  }

  private func configureReadyButton() {
    readyButton.setTitle("Готово", for: .normal)
    readyButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 17)
    readyButton.layer.cornerRadius = 8
    readyButton.backgroundColor = Colors.defaultOrange

    bottomSheetView.addSubview(readyButton)

    readyButton.snp.makeConstraints { make in
      make.top.equalTo(stackView.snp.bottom).inset(-12)
      make.right.left.equalToSuperview().inset(24)
    }
    readyButton.addTarget(self, action: #selector(govno), for: .touchUpInside)
    let tap = UITapGestureRecognizer(target: self, action: #selector(govno))
    view.addGestureRecognizer(tap)
  }
  @objc
  private func govno() {
    zalupa?()
  }
}
