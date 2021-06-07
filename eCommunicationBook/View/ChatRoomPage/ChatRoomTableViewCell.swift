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
    var roomName = "chat room"
    if let members = viewModel?.members {
      let membersExceptUser = members.filter({$0 != UserManager.shared.user.id})
      
      
      for member in membersExceptUser {
        
        
        
        XXXManager.shared.identifyUser(uid: member) { [weak self] result in
          
          switch result {
            
          case .success(let user):
            if roomName == "chat room" {
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
    
    //    if index == 0 {
    //      userImage.loadImage("https://images.unsplash.com/photo-1621873982312-1f83e89a2f21?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2734&q=80")
    //    } else {
    //      userImage.loadImage("https://images.unsplash.com/photo-1611867967135-0faab97d1530?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2852&q=80")
    //    }
    
    
    userImage.contentMode = .scaleAspectFill
    userImage.layoutIfNeeded()
    
    guard let messageToShow = viewModel?.messages else {
      self.message.text = "start a conversation"
      return
    }
    message.text = messageToShow[0].content + " . " + Date(milliseconds: messageToShow[0].createdTime).convertToString(dateformat: .dateWithTimeWithOutYear)
  }
  
}
