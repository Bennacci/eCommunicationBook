//
//  ServiceCollectionViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var height: NSLayoutConstraint!
  @IBOutlet weak var serviceIcon: UIImageView!
  @IBOutlet weak var servicename: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
