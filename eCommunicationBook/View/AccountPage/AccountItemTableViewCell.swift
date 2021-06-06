//
//  AccountItemTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/6.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class AccountItemTableViewCell: UITableViewCell {
  
  @IBOutlet weak var labelTitle: UILabel!
  @IBOutlet weak var labelContent: UILabel!
  
  var viewModel: [[String]]?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setUp(viewModel: [[String]], indexPath: IndexPath) {
    self.viewModel = viewModel
    layOutCell(indexPath: indexPath)
  }
  
  
  func layOutCell(indexPath: IndexPath) {
    guard let title = viewModel?[indexPath.section][indexPath.row] else {return}
    labelTitle.text = title
    var content = ""
    if title == "Display name" {
      content = UserManager.shared.user.name
    } else if title == "Local number" {
      content = "\(UserManager.shared.user.homePhoneNo)"
    } else if title == "Cell phone number" {
      content = "\(UserManager.shared.user.cellPhoneNo)"
    } else if title == "Email" {
      content = UserManager.shared.user.email
    } else if title == "Birthday" {
      var birthDay = ""
      if UserManager.shared.user.birthDay != -1 {
        birthDay = Date(milliseconds: UserManager.shared.user.birthDay).convertToString(dateformat: .dateYMD)
      }
      content = birthDay
    }
    
    if content == "" || content == "-1" {
      labelContent.text = "Not set"
      labelContent.textColor = .darkGray
    } else {
      labelContent.text = content
    }
  }
}