//
//  UIApplication+Extension.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/20.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

extension SceneDelegate: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith
                            otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

class AnyGestureRecognizer: UIGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        
        if let touchedView = touches.first?.view, touchedView is UIControl {
            
            state = .cancelled
            
        } else if let touchedView = touches.first?.view as? UITextView, touchedView.isEditable {
            
            state = .cancelled
            
        } else {
            
            state = .began
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        
        state = .cancelled
    }
}
