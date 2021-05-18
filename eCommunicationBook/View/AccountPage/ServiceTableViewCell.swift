//
//  ServiceTableViewCell.swift
//  
//
//  Created by Ben Tee on 2021/5/13.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
  
  @IBOutlet weak var serviceIcon: UIImageView!
  @IBOutlet weak var serviceLabel: UILabel!
  
  func layoutCell(accountItem: AccountItem) {
    serviceLabel.text = accountItem.title
    serviceIcon.image = accountItem.image
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = selected ? .red : .clear
    }
}
