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
    if let time = viewModel?.time {
      labelCourseTime.text = Date(milliseconds: time).convertToString(dateformat: .dateYMD)
    }
    
    if let techaerName = viewModel?.teacher.components(separatedBy: ":") {
      labelTecherName.text = techaerName[0]
    } else {
      labelTecherName.text = viewModel?.teacher
    }
    var imageTitle = ""
    
    print(viewModel?.number)
    if viewModel!.number < 10 {
      imageTitle = "0\(viewModel!.number).square.fill"
    } else {
      imageTitle = "\(viewModel!.number).square.fill"
    }
    let imageCofig = UIImage.SymbolConfiguration(weight: .bold)
    let image = UIImage(systemName: imageTitle, withConfiguration: imageCofig)
    imageView.image = image
  }
}
