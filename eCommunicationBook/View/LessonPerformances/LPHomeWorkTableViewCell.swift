//
//  LPHomeWorkTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LPHomeWorkTableViewCell: UITableViewCell {

  var viewModel: LessonPerformancesViewModel?
  
  @IBOutlet weak var labelHomeworkTitle: UILabel!
  @IBOutlet weak var checkButton: UIButton!
  
  @IBOutlet weak var checkedSquare: UIImageView!
  
  @IBOutlet weak var noCheckSquare: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func setUp(viewModel: LessonPerformancesViewModel, indexPath: IndexPath) {
      self.viewModel = viewModel
      layOutCell(indexPath: indexPath)
    }


    func layOutCell(indexPath: IndexPath) {
      guard let assignments = viewModel?.previousLesson.assignments else { return }
      labelHomeworkTitle.text =
      "\(indexPath.row + 1). \(assignments[indexPath.row])"

    }
}
