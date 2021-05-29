//
//  LPTestScoreTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/28.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LPTestScoreTableViewCell: UITableViewCell {

  var viewModel: StudentLessonRecordViewModel?
  
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
    func setUp(viewModel: StudentLessonRecordViewModel, indexPath: IndexPath) {
      self.viewModel = viewModel
      layOutCell(indexPath: indexPath)
    }


    func layOutCell(indexPath: IndexPath) {
      guard let testGrade = viewModel?.testGrade else { return }
      textFieldScore.text = testGrade[indexPath.row]
      guard let tests = viewModel?.previousTests else { return }
      labelTestTitle.text =
      "\(indexPath.row + 1). \(tests[indexPath.row])"

    }
}
