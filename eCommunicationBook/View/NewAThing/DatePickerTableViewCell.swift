//
//  DatePickerTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/20.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

protocol PickerDelegate: AnyObject {
    
    func didChangeDate(date: Date, indexPath: IndexPath)
    
    func didChangeData(type: UserType, indexPath: IndexPath)
}

class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var indexPath: IndexPath!
  
    weak var delegate: PickerDelegate?

    class func cellHeight() -> CGFloat {
        
        return 162.0
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func initView() {

        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }

    func updateCell(date: Date, indexPath: IndexPath) {

        datePicker.setDate(date, animated: true)

        self.indexPath = indexPath
    }
    
    @objc func dateDidChange(_ sender: UIDatePicker) {

        let indexPathForDisplayDate = IndexPath(row: indexPath.row - 1, section: indexPath.section)

        delegate?.didChangeDate(date: sender.date, indexPath: indexPathForDisplayDate)
    }
}
