//
//  SearchService.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 19.06.2022.
//

import Foundation

final class SearchService {
    private let catalogService = CatalogService()
    func items(with substring: String) -> [CatalogItem] {
        return catalogService
            .fetchCatalogItems()
            .filter { $0.name.lowercased().contains(substring.lowercased()) }
    }
}
