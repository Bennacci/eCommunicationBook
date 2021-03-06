//
//  Message.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCellWithNib(identifier: String, bundle: Bundle?) {
        
        let nib = UINib(nibName: identifier, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderWithNib(identifier: String, bundle: Bundle?) {
        
        let nib = UINib(nibName: identifier, bundle: bundle)
        
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else {
        
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        return cell
    }
}

extension UITableViewCell {
    
    static var identifier: String {
        
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    
    static var identifier: String {
        
        return String(describing: self)
    }
}
