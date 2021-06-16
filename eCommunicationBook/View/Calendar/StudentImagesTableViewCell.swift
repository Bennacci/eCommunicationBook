//
//  StudentImagesTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/31.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class StudentImagesTableViewCell: UITableViewCell {
  
  @IBOutlet weak var labelImageTitle: UILabel!
  
  @IBOutlet weak var imageViewStudentImage: UIImageView!
  
  var viewModel: StudentLessonRecordViewModel?
  
  override func awakeFromNib() {
    
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    
    super.setSelected(selected, animated: animated)
  }
  
  func setUp(viewModel: StudentLessonRecordViewModel, index: Int) {
    
    self.viewModel = viewModel
    
    layOutCell(index: index)
  }
  
  
  func layOutCell(index: Int) {
    
    if let imageTitle = viewModel?.imageTitles?[index],
      
      let imageUrl = viewModel?.images?[index] {
      
      if imageTitle == String.empty{
        
        labelImageTitle.text = "Today's Image"
        
      } else {
        
        labelImageTitle.text = imageTitle
      }
      
      let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
      
      let cloudImage = UIImage(systemName: "icloud.and.arrow.up.fill", withConfiguration: boldConfig)
      
      imageViewStudentImage.loadImage(imageUrl, placeHolder: cloudImage)
    }
  }
}
