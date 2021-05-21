//
//  DateTableViewCell.swift
//  InlineDatePicker
//
//  Created by Rajtharan Gopal on 07/06/18.
//  Copyright © 2018 Rajtharan Gopal. All rights reserved.
//

import UIKit



class TwoLablesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
//    // Reuser identifier
//    class func reuseIdentifier() -> String {
//        return "DateTableViewCellIdentifier"
//    }
//
//    // Nib name
//    class func nibName() -> String {
//        return "DateTableViewCell"
//    }
    
    // Cell height
    class func cellHeight() -> CGFloat {
        return 44.0
    }

    // Awake from nib method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Update text
    func updateText(text: String, date: Date) {
        label.text = text
        secondLabel.text = date.convertToString(dateformat: .dateYMD)
    }
  func updateText(text: String, type: String) {
      label.text = text
      secondLabel.text = type
  }

}
