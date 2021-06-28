//
//  ChatRoomTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewUserIcon: UIImageView!
    
    @IBOutlet weak var labelChatRoomName: UILabel!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
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
                            
                            roomName = String.empty
                            
                        } else {
                            
                            roomName += ", "
                        }
                        
                        roomName += user.name
                        
                        self?.labelChatRoomName.text = roomName
                        
                        if user.image != String.empty {
                            
                            self?.imageViewUserIcon.loadImage(user.image)
                            
                        } else {
                            
                            self?.imageViewUserIcon.image = UIImage(systemName: "person.circle")
                        }
                        
                    case .failure(let error):
                        
                        print("fetchData.failure: \(error)")
                    }
                }
            }
        }
        
        labelChatRoomName.text = roomName
        
        imageViewUserIcon.contentMode = .scaleAspectFill
        
        imageViewUserIcon.layoutIfNeeded()
        
        guard let messageToShow = viewModel?.messages else {
            
            self.labelMessage.text = "start a conversation"
            
            return
        }
        
        if messageToShow.isEmpty {
            
            self.labelMessage.text = "start a conversation"
            
        } else {
            
            let time = Date(milliseconds: messageToShow[0].createdTime)
                .convertToString(dateformat: .dateWithTimeWithOutYear)
            
            labelMessage.text = messageToShow[0].content + " . " + time
        }
    }
}
