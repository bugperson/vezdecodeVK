//
//  CategoryService .swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation

final class CategoryService {
    private let jsonProvider = JSONProvider()

    func fetchCategorys() -> [Category]? {
        let dtos: [CategoryDTO]? = jsonProvider
            .fetchJSON(named: "categories")
        return dtos.map { dto in
            return dto.map { category in Category(with: category) }
        }
    }
}
