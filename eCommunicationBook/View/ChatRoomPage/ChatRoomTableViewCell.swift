//
//  ChatRoomTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
  
  @IBOutlet weak var userImage: UIImageView!
  
  @IBOutlet weak var userID: UILabel!
  
  @IBOutlet weak var message: UILabel!
  
//  let identifier = "ChatRoomTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  var viewModel: ChatRoomViewModel?
  
  func setup(viewModel: ChatRoomViewModel) {
      self.viewModel = viewModel
      layoutCell()
  }
  
  func layoutCell() {
    var roomName = (viewModel?.members[0])!
    for index in 1..<(viewModel?.members.count)! {
      roomName += ", \((viewModel?.members[index])!)"
    }
    userID.text = roomName
    
    guard let messageToShow = viewModel?.messages?[0].content else { return }
    message.text = messageToShow
  }
}
