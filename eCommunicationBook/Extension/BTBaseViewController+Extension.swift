//
//  BTBaseViewController+Extension.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/12.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class BTBaseViewController: UIViewController {
    
    static var identifier: String {
        
        return String(describing: self)
    }
    
    var isHideNavigationBar: Bool {
        
        return false
    }
    
    var isEnableResignOnTouchOutside: Bool {
        
        return true
    }
    
    var isEnableIQKeyboard: Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isHideNavigationBar {
            navigationItem.hidesBackButton = true
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(0.9)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: String.empty, style: .plain, target: nil, action: nil)
        
        //        navigationController?.navigationBar.backIndicatorImage = UIImage.asset(.Icons_24px_Back02)
        //
        //        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.asset(.Icons_24px_Back02)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        if !isEnableIQKeyboard {
            IQKeyboardManager.shared.enable = false
        } else {
            IQKeyboardManager.shared.enable = true
        }
        
        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        } else {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        if !isEnableIQKeyboard {
            IQKeyboardManager.shared.enable = true
        } else {
            IQKeyboardManager.shared.enable = false
        }
        
        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        } else {
            IQKeyboardManager.shared.enable = false
        }
    }
    
    @IBAction func popBack(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToRoot(_ sender: Any) {
        
        backToRoot(completion: nil)
    }
    
}

extension UIViewController {
    
    func backToRoot(completion: (() -> Void)? = nil) {
        
        if presentingViewController != nil {
            
            let superVC = presentingViewController
            
            dismiss(animated: false, completion: nil)
            
            superVC?.backToRoot(completion: completion)
            
            return
        }
        
        if let tabbarVC = self as? UITabBarController {
            
            tabbarVC.selectedViewController?.backToRoot(completion: completion)
            
            return
        }
        
        if let navigateVC = self as? UINavigationController {
            
            navigateVC.popToRootViewController(animated: false)
        }
        
        completion?()
    }
}
