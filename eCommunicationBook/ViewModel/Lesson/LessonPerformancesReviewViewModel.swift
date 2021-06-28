//
//  LessonPlanReviewViewModel.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/6.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation

class LessonPerformancesReviewViewModel {
    
    let lessonRecordViewModel = Box([StudentLessonRecordViewModel]())
    
    var courseLesson: Int?
    
    var courseName: String?
    
    var comunicationSectionTitles: [[String]] = [[]]
    
    var lessonImageIndex = 0
    
    func setComunicationSectionTitle() {
        
        lessonImageIndex = 0
        
        comunicationSectionTitles.removeAll()
        
        for index in 0 ..< lessonRecordViewModel.value.count {
            
            var comunicationSectionTitle: [String] = []
            
            comunicationSectionTitle = [ "Today's Lesson", "Lesson Performances"]
            
            if lessonRecordViewModel.value[index].assignments != nil {
                
                comunicationSectionTitle.append("Homework")
            }
            
            if lessonRecordViewModel.value[index].tests != nil {
                
                comunicationSectionTitle.append("Tests")
            }
            
            if lessonRecordViewModel.value[index].assignmentScore != nil {
                
                comunicationSectionTitle.append("Homework Score")
            }
            
            if lessonRecordViewModel.value[index].testGrade != nil {
                
                comunicationSectionTitle.append("Tests Score")
            }
            
            if lessonRecordViewModel.value[index].imageTitles != nil {
                
                comunicationSectionTitle.append("Student Images")
            }
            
            if lessonRecordViewModel.value[index].note != nil {
                
                comunicationSectionTitle.append("Communication Corner")
            }
            
            comunicationSectionTitles.append(comunicationSectionTitle)
        }
    }
    
    func fetchData() {
        
        if let name = courseName, let lesson = courseLesson {
            
            LessonManager
                .shared
                .fetchStudentLessonRecord(courseName: name, courseLesson: lesson) { [weak self] result in
                
                switch result {
                
                case .success(let studentLessonRecords):
                    
                    self?.setStudentLessonRecords(studentLessonRecords)
                    
                case .failure(let error):
                    
                    print("fetchData.failure: \(error)")
                }
            }
        }
    }
    
    func convertStudenLessonRecordsToViewModels(from records: [StudentLessonRecord]) -> [StudentLessonRecordViewModel] {
        
        var viewModels = [StudentLessonRecordViewModel]()
        
        for record in records {
            
            let viewModel = StudentLessonRecordViewModel(model: record)
            
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func setStudentLessonRecords(_ records: [StudentLessonRecord]) {
        
        lessonRecordViewModel.value = convertStudenLessonRecordsToViewModels(from: records)
        
        setComunicationSectionTitle()
    }
}
