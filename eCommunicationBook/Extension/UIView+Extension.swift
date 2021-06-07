//
//  UIView+Extension.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/28.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
  
  // Border Color
  @IBInspectable var bTBorderColor: UIColor? {
    get {
        if let color = layer.borderColor {
            return UIColor(cgColor: color)
        }
        return nil
    }
    set {
        if let color = newValue {
            layer.borderColor = color.cgColor
        } else {
            layer.borderColor = nil
        }
    }
  }
  
  // Border width
  @IBInspectable var bTBorderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  // Corner radius
  @IBInspectable var bTCornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }

  @IBInspectable var bTShadowRadius: CGFloat {
      get {
          return layer.shadowRadius
      }
      set {
          layer.shadowRadius = newValue
      }
  }
  
  @IBInspectable var bTShadowOffset: CGSize {
      get {
          return layer.shadowOffset
      }
      set {
          layer.shadowOffset = newValue
      }
  }
  
  @IBInspectable var bTShadowOpacity: Float {
    get {
      return self.layer.shadowOpacity
    }
    set {
      self.layer.shadowOpacity = newValue
    }
  }
  
  @IBInspectable var bTShadowColor: UIColor? {
    get {
        if let color = layer.shadowColor {
            return UIColor(cgColor: color)
        }
        return nil
    }
    set {
        if let color = newValue {
            layer.shadowColor = color.cgColor
        } else {
            layer.shadowColor = nil
        }
    }
  }
  
  func stickSubView(_ objectView: UIView) {
    
    objectView.removeFromSuperview()
    
    addSubview(objectView)
    
    objectView.translatesAutoresizingMaskIntoConstraints = false
    
    objectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    
    objectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    
    objectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    
    objectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  func stickSubView(_ objectView: UIView, inset: UIEdgeInsets) {
    
    objectView.removeFromSuperview()
    
    addSubview(objectView)
    
    objectView.translatesAutoresizingMaskIntoConstraints = false
    
    objectView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
    
    objectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left).isActive = true
    
    objectView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.right).isActive = true
    
    objectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom).isActive = true
  }
  
  func strokeBorder() {
    
    self.backgroundColor = .clear
    self.clipsToBounds = true
    
    let maskLayer = CAShapeLayer()
    maskLayer.frame = bounds
    maskLayer.path = UIBezierPath(rect: self.bounds).cgPath
    self.layer.mask = maskLayer
    
    let line = NSNumber(value: Float(self.bounds.width / 2))
    
    let borderLayer = CAShapeLayer()
    borderLayer.path = maskLayer.path
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.strokeColor = UIColor.white.cgColor
    borderLayer.lineDashPattern = [line]
    borderLayer.lineDashPhase = self.bounds.width / 4
    borderLayer.lineWidth = 10
    borderLayer.frame = self.bounds
    self.layer.addSublayer(borderLayer)
  }
}

extension UIImageView {
  func applyBlurEffect() {
    let blurEffect = UIBlurEffect(style: .light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(blurEffectView)
  }
}
