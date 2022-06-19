//
//  FilterCoordinator.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 18.06.2022.
//

import Foundation
import UIKit

final class FilterCoordinator {
  var filterPopUpViewController: FilterPopUpViewController?
  var didFinish: (() -> Void)?
  func start() -> UIViewController {
    let filterPopUpViewController = FilterPopUpViewController()
    filterPopUpViewController.zalupa = {
      self.filterPopUpViewController = nil
      self.didFinish?()
    }
    self.filterPopUpViewController = filterPopUpViewController
    return filterPopUpViewController
  }
}
