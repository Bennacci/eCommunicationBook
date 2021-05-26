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
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  
  func layOutCell(indexPath: IndexPath) {
    var imageTitle = ""
    if indexPath.item < 9 {
      imageTitle = "0\(indexPath.item+1).square.fill"
    } else {
      imageTitle = "\(indexPath.item+1).square.fill"
    }
    let imageCofig = UIImage.SymbolConfiguration(weight: .bold)
    let image = UIImage(systemName: imageTitle, withConfiguration: imageCofig)
    imageView.image = image
  }
}
