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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initView() {
//        pickerView.addTarget(self, action: #selector(dataDidChange), for: .valueChanged)
    }

    func updateCell(indexPath: IndexPath) {
//        pickerView.setDate(date, animated: true)
        self.indexPath = indexPath
    }

}
