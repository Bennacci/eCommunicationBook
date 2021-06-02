//
//  UIColor+Extension.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

private enum BTColor: String {
  // swiftlint:disable identifier_name

  case CyanProcess
  
  case MinionYellow
  
  case AndroidGreen
  
  case OrangeSoda
  
  case Pumpkin
  
  case B1
  
  case B2
  
  case B3
  
  case B4
  
  case B5
  
  case B6
  
  case G1
  
}

extension UIColor {
  
  static let CyanProcess = BTColor(.CyanProcess)
  
  static let MinionYellow = BTColor(.MinionYellow)
  
  static let AndroidGreen = BTColor(.AndroidGreen)
  
  static let OrangeSoda = BTColor(.OrangeSoda)
  
  static let Pumpkin = BTColor(.Pumpkin)
  
  static let B1 = BTColor(.B1)
  
  static let B2 = BTColor(.B2)
  
  static let B4 = BTColor(.B4)
  
  static let B5 = BTColor(.B6)
  
  static let G1 = BTColor(.G1)
  
  // swiftlint:enable identifier_name
  
  private static func BTColor(_ color: BTColor) -> UIColor? {
    
    return UIColor(named: color.rawValue)
  }
  
  static func hexStringToUIColor(hex: String) -> UIColor {
    
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if cString.hasPrefix("#") {
      cString.remove(at: cString.startIndex)
    }
    
    if (cString.count) != 6 {
      return UIColor.gray
    }
    
    var rgbValue: UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
}
