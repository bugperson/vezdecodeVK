//
//  AppCoordinator.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation
import UIKit

final class AppCoordinator {
 
    let window: UIWindow
    var catalogCoordinator: CatalogCoordinator?
    init(window: UIWindow) {
        self.window = window
        window.makeKeyAndVisible()
    }

    func start() {
        startCatalogCoordinator()
    }

    private func startCatalogCoordinator() {
        let catalogCoordinator = CatalogCoordinator()
        changeRootViewController(catalogCoordinator.container)
        self.catalogCoordinator = catalogCoordinator
        catalogCoordinator.start()
    }

    private func changeRootViewController(_ viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
