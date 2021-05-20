//
//  CircleUserCollectionViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class CircleUserCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  var viewModel: UserViewModel?
  
  func setup(viewModel: UserViewModel) {
      self.viewModel = viewModel
      layoutCell()
  }
  
  func layoutCell() {
    userName.text = viewModel?.name
    userImage.layer.cornerRadius = userImage.frame.height / 2
    layoutIfNeeded()
  }
  
}
