//
//  CatalogService.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation

final class CatalogService {
    private let jsonProvider = JSONProvider()

    func fetchCatalogItems(for categoryID: Int) -> [CatalogItem]? {
        let dtos: [CatalogItemDTO]? = jsonProvider
            .fetchJSON(named: "products")
        return dtos.map { dto in
            return dto.compactMap { CatalogItem(with: $0) }
        }?.filter { $0.categoryId == categoryID }
    }

  func fetchCatalogItems() -> [CatalogItem] {
    let dtos: [CatalogItemDTO]? = jsonProvider
        .fetchJSON(named: "products")
    return dtos.map { dto in
        return dto.compactMap { CatalogItem(with: $0) }
    } ?? []
  }
}
