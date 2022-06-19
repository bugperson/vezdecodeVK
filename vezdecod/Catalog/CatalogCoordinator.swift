//
//  CatalogCoordinator.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation
import UIKit

final class CatalogCoordinator {
  var catalogViewController: CatalogViewController?

  var container: UINavigationController = { () -> UINavigationController in
    let navigationController = UINavigationController()
    navigationController.setNavigationBarHidden(true, animated: false)
    return navigationController
  }()

  func start() {
    let catalogViewController = CatalogViewController()
    self.catalogViewController = catalogViewController
    catalogViewController.filterPopUpAction = {
      self.showFilters()
    }
    catalogViewController.searchDidTap = {
      self.showSearch()
    }

    catalogViewController.cartButtonDidTouch = {
      self.showCart()
    }

    container.setViewControllers([catalogViewController], animated: true)
  }

  private func showCart() {
    let cartCoordinator = CartCoordinator()
    let vc = cartCoordinator.start()
    container.pushViewController(vc, animated: true)
    cartCoordinator.onFinish = {
      self.container.popViewController(animated: true)
    }
  }

  private func showSearch() {
    let searchCoordinator = SearchCoordinator()
    let vc = searchCoordinator.start()
    container.pushViewController(vc, animated: true)
    searchCoordinator.onFinish = {
      self.container.popViewController(animated: true)
    }
  }

  private func showFilters() {
    let filtersCoordinator = FilterCoordinator()
    let vc = filtersCoordinator.start()
    container.present(vc, animated: true)
    filtersCoordinator.didFinish = {
      vc.dismiss(animated: true)
    }
  }
}
