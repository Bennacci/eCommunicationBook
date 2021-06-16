//
//  LessonsCollectionViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LessonCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var labelTecherName: UILabel!
  
  @IBOutlet weak var labelCourseTime: UILabel!
  
  @IBOutlet weak var buttonEdit: UIButton!
  
  @IBOutlet weak var buttonScan: UIButton!
  
  @IBOutlet weak var buttonInspect: UIButton!
  
  var viewModel: LessonViewModel?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  func setUp(viewModel: LessonViewModel) {
    self.viewModel = viewModel
    layOutCell()
  }
  
  
  func layOutCell() {
    if let techaerName = viewModel?.teacher.components(separatedBy: ":") {
      labelTecherName.text = techaerName[0]
    } else {
      labelTecherName.text = viewModel?.teacher
    }
    var imageTitle = String.empty
    
    if viewModel!.number < 10 {
      imageTitle = "0\(viewModel!.number).square.fill"
    } else {
      imageTitle = "\(viewModel!.number).square.fill"
    }
    let imageCofig = UIImage.SymbolConfiguration(weight: .bold)
    let image = UIImage(systemName: imageTitle, withConfiguration: imageCofig)
    imageView.image = image
    
    if let time = viewModel?.time {
      labelCourseTime.text = Date(milliseconds: time).convertToString(dateformat: .dateYMD)
    }
    
    if UserManager.shared.user.userType == "teacher" {

      if let time = viewModel?.time,
        time + CalendarHelper.shared.secondsPerDay / 2 * 1000 >= Date().millisecondsSince1970 &&
          time - CalendarHelper.shared.secondsPerDay / 2 * 1000 <= Date().millisecondsSince1970 {
        buttonScan.isHidden = false
      } else {
        buttonScan.isHidden = true
      }
      
      if let time = viewModel?.time, time + CalendarHelper.shared.secondsPerDay * 1 * 1000 <= Date().millisecondsSince1970 {
        buttonEdit.isHidden = true
        buttonInspect.isHidden = false
      } else {
        buttonEdit.isHidden = false
        buttonInspect.isHidden = true
      }
    } else {
      
      buttonScan.isHidden = true
      buttonEdit.isHidden = true
      
      if let time = viewModel?.time, time + CalendarHelper.shared.secondsPerDay * 1 * 1000 <= Date().millisecondsSince1970 {
        buttonInspect.isHidden = false
        buttonInspect.setTitle("Read", for: .normal)
        buttonInspect.backgroundColor = UIColor.AndroidGreen
      } else {
        buttonInspect.isHidden = true
      }
    }
  
  
  }
}
