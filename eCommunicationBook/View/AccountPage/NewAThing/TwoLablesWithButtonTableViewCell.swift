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
    let day = timeSelectionViewModel?.routineHouers[indexPath.section].day
    secondLabel.text = DayOfWeek.allCases[day ?? 1].title
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
