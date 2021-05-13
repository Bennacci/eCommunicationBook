//
//  UIStoryboard+Extension.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

private struct StoryboardCategory {

    static let main = "Main"

    static let lobby = "Lobby"

    static let product = "Product"

    static let trolley = "Trolley"

    static let profile = "Profile"

    static let auth = "Auth"
}

extension UIStoryboard {

    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }

    static var lobby: UIStoryboard { return stStoryboard(name: StoryboardCategory.lobby) }

    static var product: UIStoryboard { return stStoryboard(name: StoryboardCategory.product) }

    static var trolley: UIStoryboard { return stStoryboard(name: StoryboardCategory.trolley) }

    static var profile: UIStoryboard { return stStoryboard(name: StoryboardCategory.profile) }

    static var auth: UIStoryboard { return stStoryboard(name: StoryboardCategory.auth) }

    private static func stStoryboard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}
