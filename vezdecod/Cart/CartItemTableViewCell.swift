//
//  CartItemTableViewCell.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation
import UIKit
import SnapKit
import Combine

final class CartHeader: UIView {
    private let backImageView = UIImageView(image: Images.chevron)
    var onTap: (() -> Void)?

    private let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "Корзина"
        return label
    }()

    private let bottomSeparator: UIView = {
        let separator = UIView()
        separator.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        separator.backgroundColor = .systemGray6
        return separator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnArrrow))
        backImageView.addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func tapOnArrrow() {
        onTap?()
    }

    private func configureView() {
        addSubview(backImageView)
        backImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(9)

            $0.top.equalToSuperview().inset(30)
            $0.size.equalTo(CGSize(width: 18, height: 24))
        }

        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
            $0.leading.greaterThanOrEqualTo(backImageView.snp.trailing)
            $0.trailing.greaterThanOrEqualToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
      backImageView.isUserInteractionEnabled = true
    }
}

final class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartService.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CartItemTableViewCell.id, for: indexPath) as? CartItemTableViewCell
        else {
            return UITableViewCell()
        }
        guard indexPath.row < cartService.items.count else {
            return UITableViewCell()
        }
        let item = cartService.items[indexPath.row]
        let config = CartItemTableViewCell.Configuration(
            itemImage: Images.burger,
            title: item.item.name,
            stepperConfiguration: MenuItemStepper.Configuration(
                quantity: "\(item.quantity)",
                onMinusPressed: {
                    self.cartService.removeItem(item.item)
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.impactOccurred()
                },
                onPlusPressed: {
                    self.cartService.appendItem(item.item)
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.impactOccurred()
                }
            ),
            actualPrice: "\(item.item.actualPrice)",
            originalPrice: item.item.originalPrice.map {"\($0)"}
        )
        cell.selectionStyle = .none
        cell.update(config: config)
        return cell
    }
    var onChevronTap: (() -> Void)? {
        didSet {
            headerView.onTap = onChevronTap
        }
    }

    private let tableView = UITableView()
    private let cartService = CartService.shared
    private let cartButtonView = CartButtonView()
    private var cartHeightConstaint: Constraint? = nil
    private var bag: AnyCancellable?
    private let headerView = CartHeader()
    private let sorryLabel: UILabel = {
        let label = UILabel()
        label.text = """
    Пусто, выберите блюда
 в каталоге :)
"""
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViews()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.bag = self.cartService.$items
                .sink { items in

                    var sum: Decimal = 0.0

                    for i in items {
                        sum += i.item.actualPrice * Decimal(i.quantity)
                    }

                    if sum < 0.01 {
                        self.hideCartButton()
                    } else {
                        self.showCartButton()
                    }

                  self.cartButtonView.update(text: "Заказать за \(PriceFormatter.formatte(value: "\(sum)", currency: "₽"))", pic: nil)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.tableView.reloadData()
                    }

            }
        }
    }

    private func configureViews() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.trailing.leading.equalToSuperview()
        }

        configureTableView()
        configureCartButton()
        view.addSubview(sorryLabel)
        sorryLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        sorryLabel.isHidden = cartService.items.isEmpty
    }

    private func configureCartButton() {
        view.addSubview(cartButtonView)

        cartButtonView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
            self.cartHeightConstaint = $0.height.equalTo(0).constraint
        }
        cartHeightConstaint?.isActive = true
    }

    private func showCartButton() {
        tableView.isHidden = false
        sorryLabel.isHidden = true

        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.cartHeightConstaint?.isActive = false
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 0)
                self.cartButtonView.superview?.layoutIfNeeded()
            }
        )
    }

    private func hideCartButton() {
        tableView.isHidden = true
        sorryLabel.isHidden = false
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.cartHeightConstaint?.isActive = true
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.cartButtonView.superview?.layoutIfNeeded()
            }
        )
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: CartItemTableViewCell.id)

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }

        tableView.isHidden = !cartService.items.isEmpty
    }
}

final class CartItemTableViewCell: UITableViewCell {
    static let id = "\(CartItemTableViewCell.self)"

    struct Configuration {
        let itemImage: UIImage
        let title: String
        let stepperConfiguration: MenuItemStepper.Configuration
        let actualPrice: String
        let originalPrice: String?
    }

    let topSeparator: UIView = {
        let separator = UIView()
        separator.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        separator.backgroundColor = .systemGray6
        return separator
    }()

    let bottomSeparator: UIView = {
        let separator = UIView()
        separator.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        separator.backgroundColor = .systemGray6
        return separator
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(15.0)

        return label
    }()

    let stepperView = MenuItemStepper()

    let actualPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 17.0)
        return label
    }()

    let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15.0)
        return label
    }()

    let menuItemImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 96, height: 96))
        }
        return imageView
    }()

    let mainStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .horizontal
        return stackView
    }()

    let bodyStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.spacing = 12
         stackView.distribution = .equalCentering
         stackView.alignment = .leading
         stackView.axis = .vertical
         return stackView
     }()

    let stepperStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
     }()

    let pricesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
         stackView.alignment = .trailing
         stackView.axis = .vertical
         return stackView
     }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(config: Configuration) {
        nameLabel.text = config.title
        menuItemImageView.image = config.itemImage

        if let originalPrice = config.originalPrice {
            let attributedText : NSMutableAttributedString =  NSMutableAttributedString(string: originalPrice + " ₽")
            attributedText.addAttributes([
                            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                            NSAttributedString.Key.strikethroughColor: UIColor.lightGray,
                            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.0),
                            NSAttributedString.Key.foregroundColor: UIColor.lightGray
                            ], range: NSMakeRange(0, attributedText.length))
            originalPriceLabel.attributedText = attributedText
            originalPriceLabel.isHidden = false
        } else {
            originalPriceLabel.isHidden = true
        }

        actualPriceLabel.text = config.actualPrice + " ₽"
        stepperView.updateConfiguration(config.stepperConfiguration)
    }

    private func configure() {
        contentView.addSubview(mainStackView)
        contentView.addSubview(actualPriceLabel)
        contentView.addSubview(originalPriceLabel)
        contentView.addSubview(topSeparator)
        contentView.addSubview(bottomSeparator)
        topSeparator.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }

        bottomSeparator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }

        mainStackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.bottom.top.equalToSuperview().inset(16)
            $0.trailing.equalTo(actualPriceLabel.snp.leading)
        }

        mainStackView.addArrangedSubview(menuItemImageView)
        mainStackView.addArrangedSubview(bodyStackView)

        bodyStackView.addArrangedSubview(nameLabel)
        bodyStackView.addArrangedSubview(stepperStackView)

        stepperStackView.addArrangedSubview(stepperView)

        actualPriceLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(41)
        }
        originalPriceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21)
            $0.right.equalToSuperview().inset(16)
        }
    }
}
