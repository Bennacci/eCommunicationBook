//
//  TwoLablesWithButtonTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/21.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class TwoLablesWithButtonTableViewCell: UITableViewCell {
  
  //  var viewModel: NewAThingViewModel?
  
  var timeSelectionViewModel: TimeSelectionViewModel?
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var secondLabel: UILabel!
  @IBOutlet weak var buttonLikeImage: UIImageView!
  @IBOutlet weak var seconLabelDisToEdge: NSLayoutConstraint!
  
  class func cellHeight() -> CGFloat {
    return 44.0
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func updateText(indexPath: IndexPath) {
    label.text = timeSelectionViewModel?.inputTexts[indexPath.section][indexPath.row]
    if timeSelectionViewModel?.inputTexts[0][indexPath.row] == "Day"{
      let day = timeSelectionViewModel?.routineHours[indexPath.section].day
      secondLabel.text = DayOfWeek.allCases[day ?? 1].title
    } else if indexPath.section == (timeSelectionViewModel?.inputTexts.count)! - 1 {
      label.isHidden = true
      secondLabel.isHidden = false
      secondLabel.text = "tap to add"
      buttonLikeImage.isHidden = true
      seconLabelDisToEdge.constant = 16
    } else {
      label.isHidden = false
      secondLabel.isHidden = true
      label.text = "tap to delete"
      buttonLikeImage.isHidden = true
    }
    
  }
  
  func updateText(text: String) {
    label.text = text
    //      if numbers == 0... -> ""
    if text == "Lesson Schedule"{
      secondLabel.isHidden = true
    } else if text == "Teachers" {
      secondLabel.text = String(describing: UserManager.shared.selectedUsers.count)
    } else {
      secondLabel.text = String(describing: UserManager.shared.selectedUsersTwo.count)
    }
  }
}
