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
    
    @IBOutlet weak var lableUserName: UILabel!
    
    @IBOutlet weak var labelMessageContent: UILabel!
    
    @IBOutlet weak var labelMessageTime: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    var viewModel: MessageViewModel?
    
    func setup(viewModel: MessageViewModel, user: User) {
        
        self.viewModel = viewModel
        
        layoutCell(user: user)
    }
    
    func layoutCell(user: User) {
        
        labelMessageContent.text = viewModel?.content
        
        lableUserName.text = user.name
        
        imageVIewPartner.loadImage(user.image)
        
        imageVIewPartner.contentMode = .scaleAspectFill
        
        imageVIewPartner.layoutIfNeeded()
        
        if let time = viewModel?.createdTime {
            
            let timeString = Date(milliseconds: time).convertToString(dateformat: .dateWithTimeWithOutYear)
            
            labelMessageTime.text = timeString
        }
    }
}
