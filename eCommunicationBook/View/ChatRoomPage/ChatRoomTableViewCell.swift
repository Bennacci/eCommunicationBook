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
    var roomName = "chat"
    if let members = viewModel?.members {
      let membersExceptUser = members.filter({$0 != UserManager.shared.user.id})
      
      
      for member in membersExceptUser {
        
        UserManager.shared.identifyUser(uid: member) { [weak self] result in
          
          switch result {
            
          case .success(let user):
            if roomName == "chat" {
              roomName = ""
            } else {
              roomName += ", "
            }
            
            roomName += user.name
            
            self?.userID.text = roomName

            if user.image != "" {
              self?.userImage.loadImage(user.image)
            } else {
              self?.userImage.image = UIImage(systemName: "person.circle")
            }
          case .failure(let error):
            
            print("fetchData.failure: \(error)")
          }
        }
      }
    }
    
    
    userID.text = roomName

    userImage.contentMode = .scaleAspectFill
    userImage.layoutIfNeeded()
    
    guard let messageToShow = viewModel?.messages else {
      self.message.text = "start a conversation"
      return
    }
    message.text = messageToShow[0].content + " . " + Date(milliseconds: messageToShow[0].createdTime).convertToString(dateformat: .dateWithTimeWithOutYear)
  }
  
}
