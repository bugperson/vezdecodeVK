//
//  CatalogItemDto.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation

struct CatalogItemDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case name
        case description
        case image
        case actualPrice = "price_current"
        case originalPrice = "price_old"
        case measure
        case measureUnit = "measure_unit"
        case energyPer100Grams = "energy_per_100_grams"
        case proteinsPer100Grams = "proteins_per_100_grams"
        case fatsPer100Grams = "fats_per_100_grams"
        case carbohydratesPer100Grams = "carbohydrates_per_100_grams"
        case tagIds = "tag_ids"

    }

    let id: Int
    let categoryId: Int
    let name: String
    let description: String
    let image: String
    let actualPrice: Decimal
    let originalPrice: Decimal?
    let measure: Decimal
    let measureUnit: String
    let energyPer100Grams: Decimal
    let proteinsPer100Grams: Decimal
    let fatsPer100Grams: Decimal
    let carbohydratesPer100Grams: Decimal
    let tagIds: [Int]
}

/*
 {
     "id": 36,
     "category_id": 676171,
     "name": "Запеченный ролл с курицей 3шт",
     "description": "Ролл с курицей, огурцом и сливочным сыром, запеченный под икрой летучей рыбы, легким майонезом и сыром  Комплектуется бесплатным набором для роллов (Соевый соус Лайт 35г., васаби 6г., имбирь 15г.). +1 набор за каждые 600 рублей в заказе",
     "image": "1.jpg",
     "price_current": 23000,
     "price_old": 41333,
     "measure": 125,
     "measure_unit": "г",
     "energy_per_100_grams": 234.8,
     "proteins_per_100_grams": 5.4,
     "fats_per_100_grams": 17.3,
     "carbohydrates_per_100_grams": 15,
     "tag_ids": []
 },
 */
