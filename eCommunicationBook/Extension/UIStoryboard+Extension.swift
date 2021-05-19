//
//  UIStoryboard+Extension.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

private struct StoryboardCategory {
  
  static let newAClass = "NewAClass"
  
  static let searchUser = "SearchUser"
  
  static let newEvent = "NewEvent"
  
  static let setASign = "SetASign"
  
  static let writeAttendAndLeave = "WriteAttendAndLeave"
  
  static let writeLessonState = "WriteLessonState"
  
  static let checkLearingStat = "CheckLearingStat"
  
  static let payTimeAnnounce = "PayTimeAnnounce"
  
  static let contactUs = "ContactUs"
  
  static let leaveReservation = "LeaveReservation"
  
  static let courseReservation = "CourseReservation"
  
  static let makeUpReservation = "MakeUpReservation"
}

extension UIStoryboard {
  
  static var newAClass: UIStoryboard { return storyboard(name: StoryboardCategory.newAClass) }
  
    static var searchUser: UIStoryboard { return storyboard(name: StoryboardCategory.searchUser) }
  
  static var newEvent: UIStoryboard { return storyboard(name: StoryboardCategory.newEvent) }
  
  static var setASign: UIStoryboard { return storyboard(name: StoryboardCategory.setASign) }
  
  static var writeAttendAndLeave: UIStoryboard { return storyboard(name: StoryboardCategory.writeAttendAndLeave) }
  
  static var writeLessonState: UIStoryboard { return storyboard(name: StoryboardCategory.writeLessonState) }
  
  static var checkLearingStat: UIStoryboard { return storyboard(name: StoryboardCategory.checkLearingStat) }
  
  static var payTimeAnnounce: UIStoryboard { return storyboard(name: StoryboardCategory.payTimeAnnounce) }
  
  static var contactUs: UIStoryboard { return storyboard(name: StoryboardCategory.contactUs) }
  
  static var leaveReservation: UIStoryboard { return storyboard(name: StoryboardCategory.leaveReservation) }
  
  static var courseReservation: UIStoryboard { return storyboard(name: StoryboardCategory.courseReservation) }
  
  static var makeUpReservation: UIStoryboard { return storyboard(name: StoryboardCategory.makeUpReservation) }

  private static func storyboard(name: String) -> UIStoryboard {
    
    return UIStoryboard(name: name, bundle: nil)
  }
}
