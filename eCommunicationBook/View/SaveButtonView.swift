//
//  PublishB.swift
//  Midterm_Ben
//
//  Created by Ben Tee on 2021/5/7.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

class SaveButtonView: UIView {
  
  lazy var saveButton : UIButton = {
    let btn = UIButton()
    btn.isUserInteractionEnabled = true
    btn.frame = CGRect(x: 0,
                       y: 0,
                       width: 50,
                       height: 50)
    btn.layer.cornerRadius = 25
    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
    let btnImage = UIImage(systemName: "icloud.and.arrow.up.fill", withConfiguration: boldConfig)
    btn.setImage(btnImage, for: .normal)
    btn.tintColor = .white
    btn.imageView?.contentMode = .scaleAspectFill
    btn.contentVerticalAlignment = .fill
    btn.contentHorizontalAlignment = .fill
    btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    btn.backgroundColor = UIColor(red: 103/255, green: 52/255, blue: 186/255, alpha: 1)
    return btn
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func initSubView(){
    self.addSubview(saveButton)
  }
}
