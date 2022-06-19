//
//  CatalogViewController.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import UIKit
import SnapKit
import Combine

class CatalogViewController: UIViewController {
  private let catalogService = CatalogService()
  private let headView = CatalogHaedView(frame: .zero)
  private var catalogItems: [CatalogItem]?
  private let cartButtonView = CartButtonView()

  var filterPopUpAction: (() -> Void)? {
    didSet {
      headView.onTap = filterPopUpAction
    }
  }

  var searchDidTap: (() -> Void)? {
    didSet {
      headView.onTapSearch = searchDidTap
    }
  }

  var cartButtonDidTouch: (() -> Void)? = nil

  @objc
  private func kdsfsdlfsjdfl() {
    cartButtonDidTouch?()
  }

  private let catalogItemsCollectionView: UICollectionView = {
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

  private let filterSectionViewController = FilterSectionViewController()

  private var bag: AnyCancellable? = nil
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    configureCatalogHaed()
    configurecataFilterSectionViewController()
    configureCartButton()
    configurecataCatalogItemsCollection()

    bag = CartService.shared.$items.sink { item in
      var sum: Decimal = 0.0
      for i in item {
        sum += Decimal(i.quantity) * i.item.actualPrice
      }

      self.heightConstaraint?.isActive = sum < 0.01
      self.cartButtonView.update(text: "\(PriceFormatter.formatte(value: "\(sum)", currency: "₽"))", pic: Images.cart)
    }
  }

  private func configurecataFilterSectionViewController() {
    addChild(filterSectionViewController)
    view.addSubview(filterSectionViewController.view)
    filterSectionViewController.didMove(toParent: self)

    filterSectionViewController.selectCategaryAction = { id in
      self.catalogItems = self.catalogService.fetchCatalogItems(for: id)
      self.catalogItemsCollectionView.reloadData()
    }

    filterSectionViewController.view.snp.makeConstraints { make in
      make.top.equalTo(headView.snp.bottom).inset(-8)
      make.left.right.equalToSuperview()
      make.height.equalTo(48)
    }
  }

  private func configurecataCatalogItemsCollection() {
    catalogItems = catalogService.fetchCatalogItems(for: self.filterSectionViewController.selected)

    self.catalogItemsCollectionView.dataSource = self
    self.catalogItemsCollectionView.delegate = self

    self.catalogItemsCollectionView.register(
      MenuItemCollectionViewCell.self,
      forCellWithReuseIdentifier: "cell"
    )

    self.view.addSubview(catalogItemsCollectionView)

    catalogItemsCollectionView.snp.makeConstraints { make in
      make.top.equalTo(filterSectionViewController.view.snp.bottom).inset(-16)
      make.left.right.equalToSuperview()
      make.bottom.equalTo(cartButtonView.snp.top)
    }
  }

  private var heightConstaraint: Constraint? = nil

  private func configureCartButton() {

    view.addSubview(cartButtonView)
    cartButtonView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      self.heightConstaraint = $0.height.equalTo(0).constraint
    }
    heightConstaraint?.isActive = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(kdsfsdlfsjdfl))
    cartButtonView.addGestureRecognizer(tap)
  }

  private func configureCatalogHaed() {
    self.view.addSubview(headView)
    headView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
    }
  }
}

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.catalogItems?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuItemCollectionViewCell
    let catalogItem = self.catalogItems![indexPath.item]

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
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        CartService.shared.appendItem(catalogItem)
        self.filterSectionViewController.selectCategaryAction?(self.filterSectionViewController.selected)
        self.catalogItemsCollectionView.reloadData()
      },
      onMinusTapped: {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        CartService.shared.removeItem(catalogItem)
        self.filterSectionViewController.selectCategaryAction?(self.filterSectionViewController.selected)
        self.catalogItemsCollectionView.reloadData()
      },
      onAddTapped: {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        CartService.shared.appendItem(catalogItem)
        self.filterSectionViewController.selectCategaryAction?(self.filterSectionViewController.selected)
        self.catalogItemsCollectionView.reloadData()
      }
    )
    return cell
  }
}
