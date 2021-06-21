//
//  ServicesTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class ServicesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        collectionView.registerCellWithNib(identifier: ServiceCollectionViewCell.identifier, bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
}
