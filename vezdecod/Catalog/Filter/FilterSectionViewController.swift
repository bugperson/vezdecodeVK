//
//  FilterSectionViewController.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import UIKit

final class FilterSectionViewController: UIViewController {
  private var categoryService = CategoryService()
  private var categoryItems: [Category]? {
    didSet {
      guard let categoryItems = categoryItems else {
        return
      }
      selected = categoryItems.first?.id ?? 0
    }
  }
  public var selected: Int = 0

  public var selectCategaryAction: ((Int) -> Void)?

  private let categoryItemsCollectionView: UICollectionView = {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(1),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
      leading: .fixed(8),
      top: nil,
      trailing: .fixed(8),
      bottom: nil
    )
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(80),
      heightDimension: .estimated(48)
    )
    let group = NSCollectionLayoutGroup.vertical(
        layoutSize: groupSize,
        subitem: item,
        count: 1
    )
    let section = NSCollectionLayoutSection(group: group)
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .horizontal
    let layout = UICollectionViewCompositionalLayout(
        section: section,
        configuration:config
    )

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configurecatalogItemsCollection()
  }

  private func configurecatalogItemsCollection() {
    categoryItems = categoryService.fetchCategorys()

    self.categoryItemsCollectionView.dataSource = self
    self.categoryItemsCollectionView.delegate = self

    self.categoryItemsCollectionView.register(
      FilterSectionViewControllerCell.self,
      forCellWithReuseIdentifier: "cellCategory"
    )

    self.view.addSubview(categoryItemsCollectionView)

    categoryItemsCollectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

extension FilterSectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.categoryItems?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCategory", for: indexPath) as! FilterSectionViewControllerCell
    let categoryItem = self.categoryItems![indexPath.item]
    cell.update(
      FilterSectionViewControllerCell.Configuration(
        state: selected == categoryItem.id ? .selected : .default,
        name: categoryItem.name,
        onTap: {
          self.selected = categoryItem.id
          self.categoryItemsCollectionView.reloadData()
          self.selectCategaryAction?(self.selected)
        }
      )
    )
    return cell
  }
}
