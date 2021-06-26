//
//  StudentTimeInTimeOutTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/3.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class StudentTimeInTimeOutTableViewCell: UITableViewCell {
    
    var timeInViewModel: StudentExistanceViewModel?
    
    var timeOutViewModel: StudentExistanceViewModel?
    
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var labelCourseName: UILabel!
    
    @IBOutlet weak var labelTimeInTime: UILabel!
    
    @IBOutlet weak var labelTimeOutTime: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(timeInViewModel: StudentExistanceViewModel, timeOutViewModel: StudentExistanceViewModel?) {
        
        self.timeInViewModel = timeInViewModel
        
        if timeOutViewModel != nil {
            
            self.timeOutViewModel = timeOutViewModel
        }
        
        layOutCell()
    }
    
    func layOutCell() {
        
        guard let timeInTime = timeInViewModel?.time else {return}
        
        labelDate.text = Date(milliseconds: timeInTime).convertToString(dateformat: .day)
        
        labelTimeInTime.text = Date(milliseconds: timeInTime).convertToString(dateformat: .time)
        
        guard let courseName = timeInViewModel?.courseName.components(separatedBy: ":") else {return}
        
        labelCourseName.text =  "Class: \(courseName[0])"
        
        guard let timeOutTime = timeOutViewModel?.time else {return}
        
        labelTimeOutTime.text = Date(milliseconds: timeOutTime).convertToString(dateformat: .time)
        
        print(Date(milliseconds: timeOutTime).convertToString(dateformat: .time))
    }
}
