//
//  LableWithVerticalLineTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/24.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LableWithVerticalLineTableViewCell: UITableViewCell {

  @IBOutlet weak var labelEventTitle: UILabel!
  class func cellHeight() -> CGFloat {
    return 44.0
  }
  var viewModel: EventViewModel?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUp(viewModel: EventViewModel) {
      self.viewModel = viewModel
      layOutCell()
    }
    
    
    func layOutCell() {
      labelEventTitle.text = viewModel?.eventName
      
    }
}
