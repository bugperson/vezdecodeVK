//
//  Colors.swift
//  vezdecod
//
//  Created by Danil Dubov on 18.06.2022.
//

import UIKit

struct Colors {
  static let menuItemGrey = UIColor(red: 116, green: 116, blue: 116, alpha: 0.08)
  static let measureGrey = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
  static let defaultwhite = UIColor(red: 255, green: 255, blue: 255)
  static let defaultOrange = UIColor(red: 241, green: 84, blue: 18)
  static let defaultBlack = UIColor.black
}

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(
          red: CGFloat(red) / 255.0,
          green: CGFloat(green) / 255.0,
          blue: CGFloat(blue) / 255.0,
          alpha: alpha
       )
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
