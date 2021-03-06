//
//  TodaysLesoonTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/31.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class TodaysLesoonTableViewCell: UITableViewCell {
    
    var viewModel: StudentLessonRecordViewModel?
    
    @IBOutlet weak var labelContentsTitle: UILabel!
    
    @IBOutlet weak var labelContents: UILabel!
    
    @IBOutlet weak var labelContentMarks: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(viewModel: StudentLessonRecordViewModel, title: String) {
        
        self.viewModel = viewModel
        
        layOutCell(title: title)
    }
    
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    
    func layOutCell(title: String) {
        
        var stringRepresentation = String.empty
        
        var stringRepresentationMarks = String.empty
        
        switch title {
        
        case ComunicationSectionTitles.todaysLesson.rawValue:
            
            guard let todaysLesson = viewModel?.todaysLesson else { return }
            
            for index in 0 ..< todaysLesson.count {
                
                stringRepresentation += ("\(index + 1). " + todaysLesson[index] + "\n")
            }
            
        case ComunicationSectionTitles.homework.rawValue:
            
            guard let assignments = viewModel?.assignments else { return }
            
            for index in 0 ..< assignments.count {
                
                stringRepresentation += ("\(index + 1). " + assignments[index] + "\n")
            }
            
        case ComunicationSectionTitles.test.rawValue:
            
            guard let tests = viewModel?.tests else { return }
            
            for index in 0 ..< tests.count {
                
                stringRepresentation += ("\(index + 1). " + tests[index] + "\n")
            }
            
        case ComunicationSectionTitles.homeworkScore.rawValue:
            
            guard let assignmets = viewModel?.previousAssignments else { return }
            
            for index in 0 ..< assignmets.count {
                
                stringRepresentation += ("\(index + 1). " + assignmets[index] + "\n")
            }
            
            guard let assignmetsCompleted = viewModel?.assignmentCompleted else { return }
            
            for index in 0 ..< assignmetsCompleted.count {
                
                if assignmetsCompleted[index] == true {
                    
                    stringRepresentationMarks += ("☑︎" + "\n")
                    
                } else {
                    
                    stringRepresentationMarks += ("□" + "\n")
                }
            }
            
        case ComunicationSectionTitles.testsScore.rawValue:
            
            guard let previousTests = viewModel?.previousTests else { return }
            
            for index in 0 ..< previousTests.count {
                
                stringRepresentation += ("\(index + 1). " + previousTests[index] + "\n")
            }
            
            guard let testGrades = viewModel?.testGrade else { return }
            
            for index in 0 ..< testGrades.count {
                stringRepresentationMarks += (testGrades[index] + "\n")
            }
            
        case ComunicationSectionTitles.communicationCorner.rawValue:
            
            if let note = viewModel?.note {
                
                stringRepresentation = note
            }
            
        default:
            
            return
        }
        
        if stringRepresentation.suffix(1) == "\n" {
            
            stringRepresentation.removeLast()
        }
        
        if title == "Homework Score" || title == "Tests Score" {
            
            if stringRepresentationMarks.suffix(1) == "\n" {
                
                stringRepresentationMarks.removeLast()
            }
            
            labelContentMarks.isHidden = false
        }
        
        labelContentsTitle.text = title
        
        labelContents.text = stringRepresentation
        
        labelContentMarks.text = stringRepresentationMarks
    }
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length
}
