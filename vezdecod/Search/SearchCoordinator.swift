//
//  SearchCoordinator.swift
//  vezdecod
//
//  Created by Aleksei Gorbunov on 19.06.2022.
//

import Foundation
import UIKit

final class SearchCoordinator {

    private var searchViewCOntroller: SearchViewController?

    var onFinish: (() ->Void)? {
        didSet {
            searchViewCOntroller?.onTapClose = onFinish
        }
    }
    func start() -> UIViewController {
        let searchViewCOntroller = SearchViewController()
        self.searchViewCOntroller = searchViewCOntroller
        searchViewCOntroller.onTapClose = {
            self.searchViewCOntroller = nil
            self.onFinish?()
        }
        return searchViewCOntroller
    }
}
