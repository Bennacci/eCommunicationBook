//
//  TwoLablesTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/20.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class TwoLablesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    
    class func cellHeight() -> CGFloat {
        
        return 44.0
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func updateText(text: String, date: Date) {
        
        label.text = text
        
        secondLabel.text = date.convertToString(dateformat: .dateYMD)
    }
    
    func updateText(text: String, type: String) {
        
        label.text = text
        
        secondLabel.text = type
    }
}
