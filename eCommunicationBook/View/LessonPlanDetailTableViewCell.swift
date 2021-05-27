//
//  lessonPlanDetailTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LessonPlanDetailTableViewCell: UITableViewCell {

  var lesson: Lesson?
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var labelIndex: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setUp(lesson: Lesson, indexPath: IndexPath){
      self.lesson = lesson
    layOutCell(indexPath: indexPath)
    }
    
    
    func layOutCell(indexPath: IndexPath) {

      labelIndex.text = "\(indexPath.row + 1)."

      switch indexPath.section {
      case 0:
        textField.text = lesson?.todaysLesson![indexPath.row]
      case 1:
        textField.text = lesson?.assignments![indexPath.row]

      default:
        textField.text = lesson?.tests![indexPath.row]

      }
    }
}
