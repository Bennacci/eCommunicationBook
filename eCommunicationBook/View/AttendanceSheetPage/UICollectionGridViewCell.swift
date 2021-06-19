//
//  UICollectionGridViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/4.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class UICollectionGridViewCell: UICollectionViewCell {
    
    var label: UILabel!
    
    var imageView: UIImageView!
    
    var paddingLeft: CGFloat = 5
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.clipsToBounds = true
        
        self.label = UILabel(frame: .zero)

        self.label.textAlignment = .center

        self.addSubview(self.label)
        
        self.imageView = UIImageView(frame: .zero)

        self.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        label.frame = CGRect(x: paddingLeft, y: 0,
                             width: frame.width - paddingLeft * 2,
                             height: frame.height)
        
        let imageWidth: CGFloat = 14
        
        let imageHeight: CGFloat = 14
        
        imageView.frame = CGRect(x: frame.width - imageWidth,
                                 y: frame.height/2 - imageHeight/2,
                                 width: imageWidth, height: imageHeight)
    }
}
