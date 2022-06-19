//
//  MenuItemStepper.swift
//  vezdecod
//
//  Created by Danil Dubov on 18.06.2022.
//

import UIKit

final class MenuItemStepper: UIView {
    struct Configuration {
        let quantity: String
        let onMinusPressed: (() -> Void)?
        let onPlusPressed: (() -> Void)?
    }

    private let plusButton = MenuItemButton()
    private let minusButton = MenuItemButton()
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17.0)

        return label
    }()
    private let stackView = UIStackView()

    private var onMinusPressed: (() -> Void)?
    private var onPlusPressed: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateConfiguration(_ config: Configuration) {
        quantityLabel.text = config.quantity
        onMinusPressed = config.onMinusPressed
        onPlusPressed = config.onPlusPressed
    }

    private func configureView() {
        configureStackView()
        configureButtons()
    }

    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 21
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }

        stackView.addArrangedSubview(minusButton)
        stackView.addArrangedSubview(quantityLabel)
        stackView.addArrangedSubview(plusButton)
    }

    private func configureButtons() {
        plusButton.update(
            configuration: MenuItemButton.Configuration(
              image: Images.plusImage,
                onTap: {
                    self.onPlusPressed?()
                    self.animateButtonTap(view: self.plusButton)
                }
            )
        )

        minusButton.update(
            configuration: MenuItemButton.Configuration(
                image: Images.minusImage,
                onTap: {
                    self.onMinusPressed?()
                    self.animateButtonTap(view: self.minusButton)
                }
            )
        )
    }

    private func animateButtonTap(view: UIView) {
        UIView.animate(
            withDuration: 0.13,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                view.alpha = 0.7
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.15,
                    delay: 0.0,
                    options: .curveEaseInOut,
                    animations: {
                        view.alpha = 1
                    }
                )
            }
        )
    }
}

final class MenuItemButton: UIView {
    struct Configuration {
        let image: UIImage
        let onTap: (() -> Void)?
    }

    private let imageView = UIImageView()
    private var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        imageView.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onGestureTap))
        addGestureRecognizer(tapGesture)
        backgroundColor = Colors.menuItemGrey
        layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(configuration: Configuration) {
        self.onTap = configuration.onTap
        self.imageView.image = configuration.image
    }

    @objc
    private func onGestureTap() {
        onTap?()
    }
}

