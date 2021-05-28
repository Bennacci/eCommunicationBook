//
//  LPMainCollectionViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LPMainCollectionViewCell: UICollectionViewCell {

  var viewModel: LessonPerformancesViewModel?
  
  @IBOutlet weak var labelStudentName: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    tableView.registerCellWithNib(identifier: LPSlideTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: LPHomeWorkTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: LPCommunicationCornerTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: LPTestScoreTableViewCell.identifier, bundle: nil)
  }
  func setUp(viewModel: LessonPerformancesViewModel, indexPath: IndexPath) {
    self.viewModel = viewModel
    layOutCell(indexPath: indexPath)
  }
  
  
  func layOutCell(indexPath: IndexPath) {

    labelStudentName.text = viewModel?.studentLessonRecordsViewModel.value[indexPath.row].studentID
    
  }
}
