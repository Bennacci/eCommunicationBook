//
//  StudentPerformanceViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/24.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class StudentLessonRecordViewModel {
    
    var studentLessonRecord: StudentLessonRecord
    
    init(model studentLessonRecord: StudentLessonRecord) {
        
        self.studentLessonRecord = studentLessonRecord
    }
    var performancesItem = ["Concentration", "Attidtude", "Participant"]
    
    var id: String {
        
        return studentLessonRecord.id
    }
    
    var studentID: String {
        
        return studentLessonRecord.studentID
    }
    
    var studentName: String {
        
        return studentLessonRecord.studentName
    }
    
    var courseName: String {
        
        return studentLessonRecord.courseName
    }
    
    var courseLesson: Int {
        
        return studentLessonRecord.courseLesson
    }
    
    var time: Double {
        
        return studentLessonRecord.time
    }
    
    var timeInterval: Int {
        
        return studentLessonRecord.timeInterval
    }
    
    var todaysLesson: [String]? {
        
        return studentLessonRecord.todaysLesson
    }
    
    var tests: [String]? {
        
        return studentLessonRecord.tests
    }
    
    var assignments: [String]? {
        
        return studentLessonRecord.assignments
    }
    
    var performances: [ClassPerformance.RawValue] {
        
        return studentLessonRecord.performances
    }
    
    var previousTests: [String]? {
        
        return studentLessonRecord.previousTests
    }
    
    var previousAssignments: [String]? {
        
        return studentLessonRecord.previousAssignments
    }
    
    var testGrade: [String]? {
        
        return studentLessonRecord.testGrade
    }
    
    var assignmentCompleted: [Bool]? {
        
        return studentLessonRecord.assignmentCompleted
    }
    
    var assignmentScore: [Int]? {
        
        return studentLessonRecord.assignmentScore
    }
    
    var note: String? {
        
        return studentLessonRecord.note
    }
    
    var images: [String]? {
        
        return studentLessonRecord.images
    }
    
    var imageTitles: [String]? {
        
        return studentLessonRecord.imageTitles
    }
}
