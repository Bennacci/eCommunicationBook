//
//  UIStoryboard+Extension.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/12.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    
    static let signInPage = "SignInPage"
    
    static let newAThing = "NewAThing"
    
    static let searchUser = "SearchUser"
    
    static let timeSelection = "TimeSelection"
    
    static let lessonPlan = "LessonPlan"
    
    static let scanStudentQR = "ScanStudentQR"
    
    static let studentTimeInAndOut = "StudentTimeInAndOut"
    
    static let attendanceSheet = "AttendanceSheet"
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return storyboard(name: StoryboardCategory.main) }
    
    static var signInPage: UIStoryboard { return storyboard(name: StoryboardCategory.signInPage) }
    
    static var newAThing: UIStoryboard { return storyboard(name: StoryboardCategory.newAThing) }
    
    static var searchUser: UIStoryboard { return storyboard(name: StoryboardCategory.searchUser) }
    
    static var timeSelection: UIStoryboard { return storyboard(name: StoryboardCategory.timeSelection) }
    
    static var lessonPlan: UIStoryboard { return storyboard(name: StoryboardCategory.lessonPlan) }
    
    static var scanStudentQR: UIStoryboard { return storyboard(name: StoryboardCategory.scanStudentQR) }
    
    static var studentTimeInAndOut: UIStoryboard { return storyboard(name: StoryboardCategory.studentTimeInAndOut) }
    
    static var attendanceSheet: UIStoryboard { return storyboard(name: StoryboardCategory.attendanceSheet) }
    
    private static func storyboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
