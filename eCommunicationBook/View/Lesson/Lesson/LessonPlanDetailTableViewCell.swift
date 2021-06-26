//
//  lessonPlanDetailTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LessonPlanDetailTableViewCell: UITableViewCell {
    
    var lesson: Lesson?
    
    @IBOutlet weak var textFieldLessonPlanDetail: UITextField!
    
    @IBOutlet weak var labelIndex: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(lesson: Lesson, indexPath: IndexPath) {
        
        self.lesson = lesson
        
        layOutCell(indexPath: indexPath)
    }
    
    func layOutCell(indexPath: IndexPath) {
        
        labelIndex.text = "\(indexPath.row + 1)."
        
        switch indexPath.section {
        
        case 0:
            
            textFieldLessonPlanDetail.text = lesson?.todaysLesson![indexPath.row]
            
        case 1:
            
            textFieldLessonPlanDetail.text = lesson?.assignments![indexPath.row]
            
        default:
            
            textFieldLessonPlanDetail.text = lesson?.tests![indexPath.row]
        }
    }
}
