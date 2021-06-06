//
//  ServiceCollectionViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import ChameleonFramework

class ServiceCollectionViewCell: UICollectionViewCell {
  
  
  var viewModel: ServiceGroup?
  
  @IBOutlet weak var viewServiceBackground: UIView!
  @IBOutlet weak var height: NSLayoutConstraint!
  @IBOutlet weak var serviceIcon: UIImageView!
  @IBOutlet weak var servicename: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  func setUp(viewModel: ServiceGroup, indexPath: IndexPath, hot: Bool) {
    self.viewModel = viewModel
    layOutCell(indexPath: indexPath, hot: hot)
  }
  
  func layOutCell(indexPath: IndexPath, hot: Bool) {
    //    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
    //    let cloudImage = UIImage(systemName: "icloud.and.arrow.up.fill", withConfiguration: boldConfig)
    //    guard let imageUrl = viewModel?.images?[indexPath.row] else {return}
    //    imageViewUploadedImage.loadImage(imageUrl, placeHolder: cloudImage)
    //  }
    if hot == true {
      
      servicename.text = self.viewModel?.items[0][indexPath.item].title
      serviceIcon.image = self.viewModel?.items[0][indexPath.item].image

    } else {
//      viewServiceBackground.backgroundColor = UIColor.flatMint()
      if let count = self.viewModel?.items[1].count {
        
        if count > indexPath.item {
          servicename.text = self.viewModel?.items[1][indexPath.item].title
          serviceIcon.image = self.viewModel?.items[1][indexPath.item].image

        } else {
          
          servicename.text = self.viewModel?.items[2][indexPath.item - count].title
          serviceIcon.image = self.viewModel?.items[2][indexPath.item - count].image

//          if self.viewModel?.items[2][indexPath.item - count].title == ""{
//            servicename.text = "New Student"
//
//          }
          
        }
      }
    }
  }
}
