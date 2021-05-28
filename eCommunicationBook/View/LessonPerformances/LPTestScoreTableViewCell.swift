//
//  LPTestScoreTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/28.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LPTestScoreTableViewCell: UITableViewCell {

  var viewModel: LessonPerformancesViewModel?
  
  @IBOutlet weak var labelTestTitle: UILabel!
  @IBOutlet weak var textFieldScore: UITextField!
  
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
      guard let tests = viewModel?.previousLesson.tests else {
        return
      }
      labelTestTitle.text =
      "\(indexPath.row + 1). \(tests[indexPath.row])"

    }
}
