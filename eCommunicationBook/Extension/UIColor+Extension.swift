//
//  UIColor+Extension.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/12.
//  Copyright © 2021 TKY co. All rights reserved.
//


import UIKit

private enum BTColor: String {
    
    case cyanProcess
    
    case minionYellow
    
    case androidGreen
    
    case orangeSoda
    
    case pumpkin
    
}

extension UIColor {
    
    static let CyanProcess = BTColor(.cyanProcess)
    
    static let MinionYellow = BTColor(.minionYellow)
    
    static let AndroidGreen = BTColor(.androidGreen)
    
    static let OrangeSoda = BTColor(.orangeSoda)
    
    static let Pumpkin = BTColor(.pumpkin)
    
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
        
        var rgbValue: UInt64 = 0
        
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            
            alpha: CGFloat(1.0)
        )
    }
}
