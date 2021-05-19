//
//  WideUserTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class WideUserTableViewCell: UITableViewCell {

  
  @IBOutlet weak var unCheckIcon: UIImageView!
  @IBOutlet weak var checkIcon: UIImageView!
  @IBOutlet weak var userImageW: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var height: NSLayoutConstraint!
  override func awakeFromNib() {
        super.awakeFromNib()
      
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  func layoutCell() {
    userImageW.layer.cornerRadius = userImageW.frame.width / 2
    layoutIfNeeded()

  }
}
