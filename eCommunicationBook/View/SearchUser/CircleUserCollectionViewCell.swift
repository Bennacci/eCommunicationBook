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
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var buttonChecked: UIButton!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  var viewModel: SearchUserPageMaterial?
  
  func setup(viewModel: SearchUserPageMaterial) {
      self.viewModel = viewModel
      layoutCell()
  }
  
  func layoutCell() {
    userName.isUserInteractionEnabled = false
    button.isUserInteractionEnabled = false
    userName.text = viewModel?.name
    userImage.loadImage(viewModel?.image, placeHolder: UIImage.asset(.CommunicationBook))
    userImage.layer.cornerRadius = userImage.frame.height / 2
    layoutIfNeeded()
  }
  
  func setUpStudent(viewModel: SearchUserPageMaterial, checked: Bool) {
      self.viewModel = viewModel
    layoutStudentCell(checked: checked)
  }
  
  func layoutStudentCell(checked: Bool) {
    userName.isUserInteractionEnabled = false
    buttonChecked.isUserInteractionEnabled = false
    
    button.isHidden = true

    if checked == true {
      buttonChecked.isHidden = false
    } else {
      buttonChecked.isHidden = true
    }
    userImage.loadImage(viewModel?.image, placeHolder: UIImage.asset(.CommunicationBook))
    userName.text = viewModel?.name
    userImage.layer.cornerRadius = userImage.frame.height / 2
    layoutIfNeeded()
  }
}
