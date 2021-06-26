//
//  CircleUserCollectionViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class CircleUserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lableUserName: UILabel!
    
    @IBOutlet weak var imageViewUserIcon: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var buttonChecked: UIButton!
    
    override func awakeFromNib() {
    
        super.awakeFromNib()
    }
    
    var viewModel: SearchUserPageMaterial?
    
    func setup(viewModel: SearchUserPageMaterial) {
        
        self.viewModel = viewModel
        
        layoutCell()
    }
    
    func layoutCell() {
        
        lableUserName.isUserInteractionEnabled = false
        
        button.isUserInteractionEnabled = false
        
        lableUserName.text = viewModel?.name
        
        imageViewUserIcon.loadImage(viewModel?.image, placeHolder: UIImage.asset(.communicationBook))
        
        imageViewUserIcon.layer.cornerRadius = imageViewUserIcon.frame.height / 2
        
        layoutIfNeeded()
    }
    
    func setUpStudent(viewModel: SearchUserPageMaterial, checked: Bool) {
        
        self.viewModel = viewModel
        
        layoutStudentCell(checked: checked)
    }
    
    func layoutStudentCell(checked: Bool) {
        
        lableUserName.isUserInteractionEnabled = false
        
        buttonChecked.isUserInteractionEnabled = false
        
        button.isHidden = true
        
        if checked == true {
            
            buttonChecked.isHidden = false
        
        } else {
        
            buttonChecked.isHidden = true
        }
        
        imageViewUserIcon.loadImage(viewModel?.image, placeHolder: UIImage.asset(.communicationBook))
        
        lableUserName.text = viewModel?.name
        
        imageViewUserIcon.layer.cornerRadius = imageViewUserIcon.frame.height / 2
        
        layoutIfNeeded()
    }
}
