//
//  ServiceTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/5.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
  
  var viewModel: ServiceGroup?

  @IBOutlet weak var serviceIcon: UIImageView!
  @IBOutlet weak var serviceLabel: UILabel!
  
  func layoutCell(accountItem: AccountItem) {
    serviceLabel.text = accountItem.title
    serviceIcon.image = accountItem.image
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = selected ? .red : .clear
    }
  
  func setUp(viewModel: ServiceGroup, indexPath: IndexPath) {
      self.viewModel = viewModel
      layOutCell(indexPath: indexPath)
    }
    
    func layOutCell(indexPath: IndexPath) {
      //    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
      //    let cloudImage = UIImage(systemName: "icloud.and.arrow.up.fill", withConfiguration: boldConfig)
      //    guard let imageUrl = viewModel?.images?[indexPath.row] else {return}
      //    imageViewUploadedImage.loadImage(imageUrl, placeHolder: cloudImage)
      //  }

  //      viewServiceBackground.backgroundColor = UIColor.flatMint()
        if let count = self.viewModel?.items[1].count {
          
          if count > indexPath.item {
            serviceLabel.text = self.viewModel?.items[1][indexPath.item].title
            serviceIcon.image = self.viewModel?.items[1][indexPath.item].image

          } else {
            
            serviceLabel.text = self.viewModel?.items[2][indexPath.item - count].title
            serviceIcon.image = self.viewModel?.items[2][indexPath.item - count].image

  //          if self.viewModel?.items[2][indexPath.item - count].title == ""{
  //            servicename.text = "New Student"
  //
  //          }
            
          }
        }
    }
}
