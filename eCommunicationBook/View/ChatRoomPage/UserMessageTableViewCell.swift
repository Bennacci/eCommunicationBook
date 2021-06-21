//
//  UserMessageTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/15.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class UserMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lableMessageContent: UILabel!
    
    @IBOutlet weak var labelMessageTime: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    var viewModel: MessageViewModel?
    
    func setup(viewModel: MessageViewModel) {
        
        self.viewModel = viewModel
        
        layoutCell()
    }
    
    func layoutCell() {
        
        lableMessageContent.text = viewModel?.content
        
        if let time = viewModel?.createdTime {
            
            let timeString = Date(milliseconds: time).convertToString(dateformat: .dateWithTimeWithOutYear)
            
            labelMessageTime.text = timeString
        }
    }
}
