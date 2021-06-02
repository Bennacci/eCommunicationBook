//
//  ChatPartnerTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/15.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class PartnerMessageTableViewCell: UITableViewCell {
  @IBOutlet weak var imageVIewPartner: UIImageView!
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
    imageVIewPartner.loadImage("https://images.unsplash.com/photo-1621873982312-1f83e89a2f21?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2734&q=80")
   imageVIewPartner.contentMode = .scaleAspectFill
    imageVIewPartner.layoutIfNeeded()
  }
}
