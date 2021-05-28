//
//  LPCommunicationCornerTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LPCommunicationCornerTableViewCell: UITableViewCell {
  
  @IBOutlet weak var textViewCommunicationCorner: UITextView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      textViewCommunicationCorner.text = "type message..."
      textViewCommunicationCorner.textColor = .lightGray

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
