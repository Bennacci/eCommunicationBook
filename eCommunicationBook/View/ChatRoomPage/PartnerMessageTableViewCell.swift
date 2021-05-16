//
//  ChatPartnerTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/15.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class PartnerMessageTableViewCell: UITableViewCell {
  @IBOutlet weak var userID: UILabel!
  @IBOutlet weak var messageContent: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  var viewModel: MessageViewModel?
   
   func setup(viewModel: MessageViewModel) {
       self.viewModel = viewModel
       layoutCell()
   }
   
   func layoutCell() {
     messageContent.text = viewModel?.content
    userID.text = viewModel?.senderID
   }
}
