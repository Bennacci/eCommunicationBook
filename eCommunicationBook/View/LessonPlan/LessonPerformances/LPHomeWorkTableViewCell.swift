//
//  LPHomeWorkTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LPHomeWorkTableViewCell: UITableViewCell {

  var viewModel: StudentLessonRecordViewModel?
  
  @IBOutlet weak var labelHomeworkTitle: UILabel!
  @IBOutlet weak var checkButton: UIButton!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func setUp(viewModel: StudentLessonRecordViewModel, indexPath: IndexPath) {
      self.viewModel = viewModel
      layOutCell(indexPath: indexPath)
    }


    func layOutCell(indexPath: IndexPath) {
      guard let assignmentCompleted = viewModel?.assignmentCompleted else { return }
      if assignmentCompleted[indexPath.row] {
        checkButton.isSelected = true
      } else {
        checkButton.isSelected = false
      }
      guard let assignments = viewModel?.previousAssignments else { return }
      labelHomeworkTitle.text =
      "\(indexPath.row + 1). \(assignments[indexPath.row])"

    }
}
