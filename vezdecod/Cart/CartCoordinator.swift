//
//  CartCoordinator.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation
import UIKit

final class CartCoordinator {
    var cartController: CartViewController?
    var onFinish: (() -> Void)? {
        didSet {
            cartController?.onChevronTap = onFinish
        }
    }

    func start() -> UIViewController {
        let cartController = CartViewController()
        self.cartController = cartController
        cartController.onChevronTap = onFinish
        return cartController
    }
}
