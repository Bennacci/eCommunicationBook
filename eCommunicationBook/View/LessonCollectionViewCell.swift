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
  
  var viewModel: LessonViewModel?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  func setUp(viewModel: LessonViewModel){
    self.viewModel = viewModel
    layOutCell()
  }
  
  
  func layOutCell() {
    if let time = viewModel?.time {
      labelCourseTime.text = Date(timeIntervalSince1970: time).convertToString(dateformat: .dateWithTime)
    }
    labelTecherName.text = viewModel?.teacher
    var imageTitle = ""
    
    print(viewModel?.number)
    if viewModel!.number < 9 {
      imageTitle = "0\(viewModel!.number + 1).square.fill"
    } else {
      imageTitle = "\(viewModel!.number + 1).square.fill"
    }
    let imageCofig = UIImage.SymbolConfiguration(weight: .bold)
    let image = UIImage(systemName: imageTitle, withConfiguration: imageCofig)
    imageView.image = image
  }
}
