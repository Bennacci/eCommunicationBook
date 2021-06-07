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
  @IBOutlet weak var labelMessageTime: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  var viewModel: MessageViewModel?
  
  func setup(viewModel: MessageViewModel, user: User) {
    self.viewModel = viewModel
    layoutCell(user: user)
  }
  
  func layoutCell(user: User) {
    messageContent.text = viewModel?.content
    userID.text = user.name
    imageVIewPartner.loadImage(user.image)
    imageVIewPartner.contentMode = .scaleAspectFill
    imageVIewPartner.layoutIfNeeded()
    if let time = viewModel?.createdTime {
      labelMessageTime.text = Date(milliseconds: time).convertToString(dateformat: .dateWithTimeWithOutYear)
    }
  }
}
