//
//  MeasureFormatter.swift
//  vezdecod
//
//  Created by Danil Dubov on 18.06.2022.
//

import Foundation

class MeasureFormatter {
  static func formatte(amount: Decimal, unit: String) -> String {
    guard !"\(amount)".contains(".0") else {
      let stringAmount = "\(amount)".prefix { $0 != "." }
      return "\(stringAmount)\(unit)"
    }
    return "\(amount)\(unit)"
  }
}
