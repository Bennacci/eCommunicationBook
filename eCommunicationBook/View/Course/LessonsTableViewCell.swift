//
//  LessonsTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LessonsTableViewCell: UITableViewCell {

  @IBOutlet weak var collectionView: UICollectionView!
  
  class func cellHeight() -> CGFloat {
    return 120.0
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    collectionView.registerCellWithNib(identifier: LessonCollectionViewCell.identifier, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
