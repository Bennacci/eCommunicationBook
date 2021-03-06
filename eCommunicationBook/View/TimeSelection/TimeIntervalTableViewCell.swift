//
//  TimeIntervalTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/23.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class TimeIntervalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textFieldHour: UITextField!
    
    @IBOutlet weak var textFieldMinute: UITextField!
    
    @IBOutlet weak var lableBetweenTextField: UILabel!
    
    @IBOutlet weak var lableRightToTextField: UILabel!
    
    override func awakeFromNib() {

        super.awakeFromNib()

        configTextField()
    }
    
    var timeSelectionViewModel: TimeSelectionViewModel?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    
        super.setSelected(selected, animated: animated)
    }
    
    func updateText(indexPath: IndexPath) {
        
        if timeSelectionViewModel?.forEvent == true {
            
            label.text = timeSelectionViewModel?.inputTextsForEvent[indexPath.row]
            
        } else {
            
            label.text = timeSelectionViewModel?.inputTexts[indexPath.section][indexPath.row]
        }
        
        lableRightToTextField.isHidden = true
        
        let time = (timeSelectionViewModel?.routineHours[indexPath.section])!.startingTime
        
        let hour = time / 100
        
        let min = time % 100
        
        if  hour > 24 || hour <= 0 {
            
            textFieldHour.text = "00"
            
        } else {
            
            textFieldHour.text = String(describing: hour)
        }
        
        if min <= 0 || min > 59 {
            
            textFieldMinute.text = "00"
            
        } else {
            
            textFieldMinute.text = String(describing: min)
            
        }
    }
    
    func updateIntervalText(indexPath: IndexPath) {
        
        if timeSelectionViewModel?.forEvent == true {
            
            label.text = timeSelectionViewModel?.inputTextsForEvent[indexPath.row]
            
        } else {
            
            label.text = timeSelectionViewModel?.inputTexts[indexPath.section][indexPath.row]
        }
        
        lableBetweenTextField.text = "hrs"
        
        let time = (timeSelectionViewModel?.routineHours[indexPath.section])!.timeInterval
        
        let hour = time / 60
        
        let min = time % 60
        
        if hour <= 0 {
            
            textFieldHour.text = "0"
            
        } else {
            
            textFieldHour.text = String(describing: hour)
        }
        
        if min <= 0 || min > 59 {
            
            textFieldMinute.text = "00"
            
        } else {
            
            textFieldMinute.text = String(describing: min)
            
        }
    }
    
    func configTextField() {
        
        textFieldHour.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        textFieldMinute.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == textFieldHour {
        
            let volume = Int(textField.text ?? "3") ?? 3
            
            if  volume > 2 || (textField.text!.count) >= 2 {
            
                textFieldMinute?.becomeFirstResponder()
            }
            
        } else if textField == textFieldMinute {
            
            if (textField.text!.count) >= 2 {
            
                textFieldMinute.resignFirstResponder()
            }
        }
    }
}
