//
//  AddRowTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class AddRowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func prepareForUploadImage() {
        
        labelDescription.text = "Tap to Upload"
    }
}
