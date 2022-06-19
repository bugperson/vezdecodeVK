//
//  CartService.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation
import Combine

final class CartService {

    struct CartItem: Codable {
        var quantity: Int
        let item: CatalogItem
    }

    @Published private(set) var items: [CartItem] = []
    static let shared = CartService()
    private var bag: AnyCancellable?

    func appendItem(_ item: CatalogItem) {
      items = items.filter { $0.quantity != 0 }
        if let anus = items.firstIndex(where: { $0.item.id == item.id }) {
            items[anus] = CartItem(quantity: items[anus].quantity + 1, item: items[anus].item)
        } else {
            items.append(CartItem(quantity: 1, item: item))
        }
    }

    func removeItem(_ item: CatalogItem) {
      items = items.filter { $0.quantity != 0 }
        if let anus = items.firstIndex(where: { $0.item.id == item.id }) {
            guard items[anus].quantity > 0 else {
                items.remove(at: anus)
                return
            }
            items[anus] = CartItem(quantity: items[anus].quantity - 1, item: items[anus].item)
        } else {
            items.append(CartItem(quantity: 1, item: item))
        }
    }

    private init() {
        defer { subscribeToItemsChanges() }
        guard
            let storedData = UserDefaults
                .standard
                .object(forKey: Constants.userDefaultsCartKey) as? Data,
            let storedCart = try? JSONDecoder().decode([CartItem].self, from: storedData)
        else {

            return
        }
        items = storedCart
    }

    private func subscribeToItemsChanges() {
        bag = $items.sink { items in
            UserDefaults.standard.set(try? JSONEncoder().encode(items), forKey: Constants.userDefaultsCartKey)
        }
    }
}

private enum Constants {

    static let userDefaultsCartKey = "service.cart2"
}
