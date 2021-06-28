//
//  UICollectionGridViewLayout.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/4.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

class UICollectionGridViewLayout: UICollectionViewLayout {
    
    var viewController: UICollectionGridViewController!

    private var itemAttributes: [[UICollectionViewLayoutAttributes]] = []
    
    private var itemsSize: [NSValue] = []
    
    private var contentSize: CGSize = CGSize.zero
        
    private var column = 0
    
    private var contentWidth: CGFloat = 0
    
    private var contentHeight: CGFloat = 0
    
    override func prepare() {
        
        if collectionView!.numberOfSections == 0 {
            
            return
        }
        
        if itemAttributes.count > 0 {
            
            return
        }
        
        itemAttributes = []
        
        itemsSize = []
        
        if itemsSize.count != viewController.cols.count {
            
            calculateItemsSize()
        }
        
        appendSectionAttributesToItemAttributes()
        
        calculateContentHeightAndSize()
    }
    
    override func invalidateLayout() {
        
        itemAttributes = []
        
        itemsSize = []
        
        contentSize = CGSize.zero
        
        super.invalidateLayout()
    }
    
    override var collectionViewContentSize: CGSize {
        
        return contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        
        var attributes: [UICollectionViewLayoutAttributes] = []
        
        for section in itemAttributes {
            
            attributes.append(contentsOf: section
                                .filter({(includeElement: UICollectionViewLayoutAttributes) -> Bool in
                                            return rect.intersects(includeElement.frame)}))
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return true
    }
    
    func appendSectionAttributesToItemAttributes() {
        
        var xOffset: CGFloat = 0
        
        var yOffset: CGFloat = 0
        
        for section in 0 ..< (collectionView?.numberOfSections)! {
            
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            
            for index in 0 ..< viewController.cols.count {
                
                let itemSize = itemsSize[index].cgSizeValue
                
                let indexPath = IndexPath(item: index, section: section)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width,
                                          height: itemSize.height).integral
                
                if section == 0 && index == 0 {
                    
                    attributes.zIndex = 1024
                    
                } else if section == 0 || index == 0 {
                    
                    attributes.zIndex = 1023
                }
                
                if section == 0 {
                    
                    var frame = attributes.frame
                    
                    frame.origin.y = self.collectionView!.contentOffset.y
                    
                    attributes.frame = frame
                }
                
                if index == 0 {
                    
                    var frame = attributes.frame
                    
                    frame.origin.x = self.collectionView!.contentOffset.x
                        + collectionView!.contentInset.left
                    
                    attributes.frame = frame
                }
                
                sectionAttributes.append(attributes)
                
                xOffset += itemSize.width
                
                column += 1
                
                if column == viewController.cols.count {
                    
                    if xOffset > contentWidth {
                        
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    
                    xOffset = 0
                    
                    yOffset += itemSize.height
                }
            }
            
            itemAttributes.append(sectionAttributes)
        }
    }
    
    func calculateContentHeightAndSize() {
        
        let attributes = itemAttributes.last!.last! as UICollectionViewLayoutAttributes
        
        contentHeight = attributes.frame.origin.y + attributes.frame.size.height
        
        contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    func calculateItemsSize() {
        
        var remainingWidth = collectionView!.frame.width -
            collectionView!.contentInset.left - collectionView!.contentInset.right
        
        var index = viewController.cols.count-1
        
        while index >= 0 {
            let newItemSize = sizeForItemWithColumnIndex(columnIndex: index,
                                                         remainingWidth: remainingWidth)
            
            remainingWidth -= newItemSize.width
            
            let newItemSizeValue = NSValue(cgSize: newItemSize)
            
            itemsSize.insert(newItemSizeValue, at: 0)
            
            index -= 1
        }
    }
    
    func sizeForItemWithColumnIndex(columnIndex: Int, remainingWidth: CGFloat) -> CGSize {
        
        let columnString = viewController.cols[columnIndex]
        
        let size = NSString(string: columnString).size(withAttributes: [
            
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        
        let width = max(remainingWidth/CGFloat(columnIndex+1), 90)
        
        return CGSize(width: ceil(width), height: size.height + 10)
    }
}
