//
//  PriceFormatter.swift
//  vezdecod
//
//  Created by Danil Dubov on 18.06.2022.
//

import Foundation

class PriceFormatter {
  static func formatte(value: String, currency: String) -> String {
    guard value.count < 9 else {
      return value.prefix(8) + "..." + "\(currency)"
    }

    return "\(value) \(currency)"
  }
}
