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
    
    } else if indexPath.section == (timeSelectionViewModel?.routineHours.count)! - 1 {
      
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
      secondLabel.text = "\(UserManager.shared.selectedDays?.count ?? 0)"
    } else if text == "Time" {
      guard let selectedDay = UserManager.shared.selectedDays else {
        secondLabel.text = ""
        return
      }
      let hrs = selectedDay[0].startingTime / 100
      let min = selectedDay[0].startingTime % 100
      var addHr = selectedDay[0].timeInterval / 60
      var addMin = selectedDay[0].timeInterval % 60
      if min + addMin >= 60 {
        addHr = hrs + addHr + 1
        addMin = (min + addMin) % 60
      } else {
        addHr = hrs + addHr
        addMin = min + addMin
      }
      secondLabel.text = "\(hrs) : \(min) - \(addHr) : \(addMin)"
    } else if text == "Teachers" {
      secondLabel.text = "\(UserManager.shared.selectedUsers?.count ?? 0) 人"
    } else {
      secondLabel.text = "\(UserManager.shared.selectedStudents?.count ?? 0) 人"
    }
  }
}
