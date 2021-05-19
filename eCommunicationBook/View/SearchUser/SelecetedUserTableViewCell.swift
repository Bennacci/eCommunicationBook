//
//  SelecetedUserTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class SelecetedUserTableViewCell: UITableViewCell {

  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var height: NSLayoutConstraint!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    collectionView.registerCellWithNib(identifier: CircleUserCollectionViewCell.identifier, bundle: nil)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
