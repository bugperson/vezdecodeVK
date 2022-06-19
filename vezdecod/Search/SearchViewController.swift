//
//  SearchViewController.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 19.06.2022.
//

import Foundation
import UIKit
import Combine

final class SearchHeader: UIView {
    private let backImageView = UIImageView(image: Images.chevron)
    var onTap: (() -> Void)?

    private let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "Поиск"
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
      backImageView.isUserInteractionEnabled = true
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
    
            $0.top.equalToSuperview().inset(40)
            $0.size.equalTo(CGSize(width: 18, height: 24))
        }

        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalToSuperview().inset(40)
            $0.leading.greaterThanOrEqualTo(backImageView.snp.trailing)
            $0.trailing.greaterThanOrEqualToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

final class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var onTapClose: (() -> Void)? {
        didSet {
            header.onTap = onTapClose
        }
    }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.catalogItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuItemCollectionViewCell
    let catalogItem = self.catalogItems[indexPath.item]

    let quantity = CartService.shared.items.first { item in
      item.item.id == catalogItem.id
    }.flatMap { $0.quantity } ?? 0

    cell.update(
      MenuItemCollectionViewCell.Configuration(
        button: quantity == 0
        ? .default(price: MenuItemCollectionViewCell.Configuration.Price(
          crossedPrice: catalogItem.originalPrice == nil ? nil : "\(catalogItem.originalPrice!)",
          actualPrice: "\(catalogItem.actualPrice)"
        ))
        : .selected(quantity: String(quantity))
        ,
        name: catalogItem.name,
        description: MeasureFormatter.formatte(
          amount: catalogItem.measure.amount,
          unit: catalogItem.measure.unit
        ),
        tagImage: nil
      ),
      onPlusTapped: {
        CartService.shared.appendItem(catalogItem)
        self.collectionView.reloadData()
      },
      onMinusTapped: {
        CartService.shared.removeItem(catalogItem)
        self.collectionView.reloadData()
      },
      onAddTapped: {
        CartService.shared.appendItem(catalogItem)
        self.collectionView.reloadData()
      }
    )
    return cell
  }

    private let header = SearchHeader()
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Найти блюдо"
        return bar
    }()
    private var bag: AnyCancellable?
    private let searchService = SearchService()
    private let sorryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = """
        Введите название блюда,
        которое ищете
        """
        return label
    }()
    @Published private var searchQuery: String = ""
    private var catalogItems: [CatalogItem] = [] {
        didSet {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    if self.sorryLabel.isHidden != !self.catalogItems.isEmpty {
                        self.sorryLabel.alpha = self.catalogItems.isEmpty ? 1 : 0
                    }
                    if self.collectionView.isHidden != self.catalogItems.isEmpty {
                        self.collectionView.alpha = self.catalogItems.isEmpty ? 0 : 1
                    }
                }, completion: { _ in
                    if self.sorryLabel.isHidden != !self.catalogItems.isEmpty {
                        self.sorryLabel.isHidden = !self.catalogItems.isEmpty
                    }
                    if self.collectionView.isHidden != self.catalogItems.isEmpty {
                        self.collectionView.isHidden = self.catalogItems.isEmpty
                    }
                }
            )
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        view.backgroundColor = .white
        bag = $searchQuery
            .sink { text in
                self.catalogItems = self.searchService.items(with: text)
                self.collectionView.reloadData()
            }
    }

    private func configureViews() {

        view.addSubview(header)
        header.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }

        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.trailing.leading.equalToSuperview().inset(16)
        }
        searchBar.delegate = self
        configurecataCatalogItemsCollection()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapSomeWhere))
        collectionView.addGestureRecognizer(tapGesture)
        view.addSubview(sorryLabel)
        sorryLabel.snp.makeConstraints {
            $0.leading.trailing.greaterThanOrEqualToSuperview()
            $0.center.equalToSuperview()
        }
    }

    @objc
    private func onTapSomeWhere() {
        searchBar.endEditing(true)
    }
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        print(searchText)
        searchQuery = searchText
    }

    private func configurecataCatalogItemsCollection() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.collectionView.register(
          MenuItemCollectionViewCell.self,
          forCellWithReuseIdentifier: "cell"
        )

        self.view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
      }

    private let collectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(292))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)



        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
      }()
}

