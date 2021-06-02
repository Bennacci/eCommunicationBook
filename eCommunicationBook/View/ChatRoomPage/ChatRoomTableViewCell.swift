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
  
  func setup(viewModel: ChatRoomViewModel, index: Int) {
      self.viewModel = viewModel
    layoutCell(index: index)
  }
  
  func layoutCell(index: Int) {
    var roomName = (viewModel?.members[0])!
    for index in 1..<(viewModel?.members.count)! {
      roomName += ", \((viewModel?.members[index])!)"
    }
    userID.text = viewModel?.members[1]
    if index == 0 {
    userImage.loadImage("https://images.unsplash.com/photo-1621873982312-1f83e89a2f21?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2734&q=80")
    } else {
          userImage.loadImage("https://images.unsplash.com/photo-1611867967135-0faab97d1530?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2852&q=80")
    }
    userImage.contentMode = .scaleAspectFill
    userImage.layoutIfNeeded()

    guard let messageToShow = viewModel?.messages?[0].content else { return }
    message.text = messageToShow
  }
}
