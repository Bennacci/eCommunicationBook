//
//  UploadImageTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/31.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class UploadImageTableViewCell: UITableViewCell {
  
  var viewModel: StudentLessonRecordViewModel?
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  @IBOutlet weak var buttonDeleteImage: UIButton!
  @IBOutlet weak var imageViewUploadedImage: UIImageView!
  @IBOutlet weak var textFieldImageTitle: UITextField!
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  func setUp(viewModel: StudentLessonRecordViewModel, indexPath: IndexPath) {
    self.viewModel = viewModel
    layOutCell(indexPath: indexPath)
  }
  
  
  func layOutCell(indexPath: IndexPath) {
    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
    let cloudImage = UIImage(systemName: "icloud.and.arrow.up.fill", withConfiguration: boldConfig)
    guard let imageUrl = viewModel?.images?[indexPath.row] else {return}
    imageViewUploadedImage.loadImage(imageUrl, placeHolder: cloudImage)
  }
}
