//
//  WideUserTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class WideUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewCircleIcon: UIImageView!
    
    @IBOutlet weak var imageViewCheckIcon: UIImageView!
    
    @IBOutlet weak var imageViewUserImage: UIImageView!
    
    @IBOutlet weak var labelUserName: UILabel!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }

    var material: SearchUserPageMaterial?
    
    func setup(list: [SearchUserPageMaterial], viewModel: SearchUserPageMaterial) {
    
        self.material = viewModel
        
        layoutCell(list: list)
    }
    
    func layoutCell(list: [SearchUserPageMaterial]) {
    
        let arrayCount = list.count
        
        var evenArray = [SearchUserPageMaterial]()
        
        evenArray = list.filter { $0.id != material?.id }
        
        if evenArray.count == arrayCount {
        
            imageViewCheckIcon.isHidden = true
            
            imageViewCircleIcon.isHidden = false
        
        } else {
        
            imageViewCheckIcon.isHidden = false
            
            imageViewCircleIcon.isHidden = true
        }
        
        labelUserName.text = material?.name
        
        if let imageURL = material?.image {
            
            imageViewUserImage.loadImage(imageURL, placeHolder: UIImage(systemName: "person.crop.circle.fill"))
        }
        
        imageViewUserImage.layer.cornerRadius = imageViewUserImage.frame.height / 2
        
        layoutIfNeeded()
    }
}
