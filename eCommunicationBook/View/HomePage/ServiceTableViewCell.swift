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
    
    @IBOutlet weak var imageViewServiceIcon: UIImageView!
    
    @IBOutlet weak var labelService: UILabel!
    
    func layoutCell(accountItem: AccountItem) {
        
        labelService.text = accountItem.title
        
        imageViewServiceIcon.image = accountItem.image
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
        
        if let count = self.viewModel?.items[1].count {
            
            if count > indexPath.item {
                
                labelService.text = self.viewModel?.items[1][indexPath.item].title
                
                imageViewServiceIcon.image = self.viewModel?.items[1][indexPath.item].image
                
            } else {
                
                labelService.text = self.viewModel?.items[2][indexPath.item - count].title
                
                imageViewServiceIcon.image = self.viewModel?.items[2][indexPath.item - count].image
            }
        }
    }
}
