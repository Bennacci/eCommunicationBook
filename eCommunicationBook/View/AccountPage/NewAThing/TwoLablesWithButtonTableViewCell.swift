//
//  TwoLablesWithButtonTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/21.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class TwoLablesWithButtonTableViewCell: UITableViewCell {

  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var secondLabel: UILabel!
  @IBOutlet weak var buttonLikeImage: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateText(text: String, numbers: Int) {
        label.text = text
//      if numbers == 0... -> ""
        secondLabel.text = String(numbers)
    }

    
}
