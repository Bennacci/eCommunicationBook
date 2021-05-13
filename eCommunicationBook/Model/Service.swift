//
//  Service.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/13.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

struct AccountService {
  
  var services: [Service]
  
  var bookingService: [BookingService]
  
  enum Service: CaseIterable {
    case learningStat
    case booking
    case announce
    case contactUs
  }
  
  enum BookingService: CaseIterable{
    case leaveReservation
    case courseReservation
    case makeUpReservation
  }
}
// let item: [[String]] = [["學習狀況"], ["線上請假", "課程預約", "補課申請"], ["繳費通知"], ["聯絡我們"]]
