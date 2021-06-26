//
//  LPMainCollectionViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LPMainCollectionViewCell: UICollectionViewCell {
  
  var viewModel: StudentLessonRecordViewModel?
  
  var forLessonPlanReview: Bool?
  
  @IBOutlet weak var labelStudentName: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
//    if forLessonPlanReview == nil {
      tableView.registerCellWithNib(identifier: LPSliderTableViewCell.identifier, bundle: nil)
      tableView.registerCellWithNib(identifier: LPHomeWorkTableViewCell.identifier, bundle: nil)
      tableView.registerCellWithNib(identifier: LPCommunicationCornerTableViewCell.identifier, bundle: nil)
      tableView.registerCellWithNib(identifier: LPTestScoreTableViewCell.identifier, bundle: nil)
      tableView.registerCellWithNib(identifier: AddRowTableViewCell.identifier, bundle: nil)
      tableView.registerCellWithNib(identifier: UploadImageTableViewCell.identifier, bundle: nil)
//    } else {
      tableView.registerCellWithNib(identifier: TodaysLesoonTableViewCell.identifier, bundle: nil)
      tableView.registerCellWithNib(identifier: StudentImagesTableViewCell.identifier, bundle: nil)
      tableView.registerCellWithNib(identifier: ChartTableViewCell.identifier, bundle: nil)
//    }
  }
    
  func setUp(viewModel: StudentLessonRecordViewModel) {
    
    self.viewModel = viewModel
    
    layOutCell()
  }
  
  func layOutCell() {
    
    //    let splits = viewModel?.studentID.components(separatedBy: ":")
    //    guard let name = splits?[0] else {return}
    labelStudentName.text = viewModel?.studentName
  }
}
