//
//  ServiceTableViewCell.swift
//  
//
//  Created by Ben Tee on 2021/5/13.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {

  var identifier = "ServiceTableViewCell"
  
  @IBOutlet weak var serviceLabel: UILabel!
  
//  var viewModel: ServiceViewModel?
//
//  func setup(viewModel: ServiceViewModel) {
//      self.viewModel = viewModel
//      layoutCell(title: view)
//  }
  
  func layoutCell(title: String) {
    serviceLabel.text = title
    
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = selected ? .red : .clear
    }

}
