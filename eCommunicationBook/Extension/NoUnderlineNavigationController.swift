//
//  NavigationController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/19.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

class NoUnderlineNavigationController: UINavigationController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        navigationBar.isTranslucent = false

        navigationBar.setBackgroundImage(UIImage(), for: .default)

        navigationBar.shadowImage = UIImage()
    }
}
