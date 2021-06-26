//
//  SceneDelegate.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/12.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        let tapGesture = AnyGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        
        tapGesture.requiresExclusiveTouchType = false
        
        tapGesture.cancelsTouchesInView = false
        
        tapGesture.delegate = self
        
        window?.addGestureRecognizer(tapGesture)
                
        window?.makeKeyAndVisible()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        
            appDelegate.window = window
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {

    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {

    }
    
    func sceneWillResignActive(_ scene: UIScene) {

    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {

        let firebaseAuth = Auth.auth()
        
//                do {
//
//                  try firebaseAuth.signOut()
//
//                } catch let signOutError as NSError {
//
//                  print("Error signing out: %@", signOutError)
//                }
        
        var storyBoard: UIStoryboard?
        
        firebaseAuth.addStateDidChangeListener { [self] _, user in
            
            if let user = user {
            
                UserManager.shared.user.id = user.uid
            }
            
            if UserManager.shared.user.userType != nil {
                
                storyBoard = .main
            
            } else {
            
                storyBoard = .signInPage
                
                guard let nextVC = storyBoard?.instantiateInitialViewController()
                        as? SignInPageViewController else {return}
                
                if UserManager.shared.user.userType != nil {
                
                    nextVC.shiftToViewChoseRole()
                }
            }
            
            self.window?.rootViewController = storyBoard?.instantiateInitialViewController()
            
            self.window?.makeKeyAndVisible()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    
    }
}
