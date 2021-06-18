//
//  TypePickerTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/20.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit


class PickerViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(indexPath: IndexPath) {
        
        self.indexPath = indexPath
    }
}
