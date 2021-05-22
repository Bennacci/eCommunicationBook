//
//  textFieldTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/20.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

  @IBOutlet var title: UILabel!
  @IBOutlet var textField: UITextField!
  
  class func cellHeight() -> CGFloat {
      return 44.0
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
