//
//  Message.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

extension UICollectionView {
  
  func registerCellWithNib(identifier: String, bundle: Bundle?) {
    
    let nib = UINib(nibName: identifier, bundle: bundle)
    
    register(nib, forCellWithReuseIdentifier: identifier)
  }
  
  func calculateCellsize(view: UIView,
                         sectionInsets: UIEdgeInsets,
                         itemsPerRow: CGFloat,
                         itemsPerColumn: CGFloat) -> CGSize {
    
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    
    let availableWidth = view.frame.width - paddingSpace
    
    let widthPerItem = availableWidth / itemsPerRow
    
    let columnPaddingSpace = sectionInsets.top * (itemsPerColumn + 1)
    
    let availableHeight = view.frame.width - columnPaddingSpace
    
    let heightPerItem = availableHeight / itemsPerRow
    
    return CGSize(width: widthPerItem, height: heightPerItem)
  }
}

extension UICollectionViewCell {
    
    static var identifier: String {
      
      return String(describing: self)
    }
}
