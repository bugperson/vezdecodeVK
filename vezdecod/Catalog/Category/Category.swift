//
//  Category.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation

struct Category {
    let id: Int
    let name: String

    init(with dto: CategoryDTO) {
        self.id = dto.id
        self.name = dto.name
    }
}
