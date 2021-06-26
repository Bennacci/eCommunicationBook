//
//  StudentExistancesTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/31.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import MapKit

class StudentExistancesTableViewCell: UITableViewCell {
    
    var timeInViewModel: StudentExistanceViewModel?
    
    var timeOutViewModel: StudentExistanceViewModel?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var labelCellTitle: UILabel!
    
    @IBOutlet weak var labelCellContent: UILabel!
    
    @IBOutlet weak var labelCellCourseName: UILabel!
    
    @IBOutlet weak var imageViewLocated: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(forCalendar: Bool,
               timeInViewModel: StudentExistanceViewModel,
               timeOutViewModel: StudentExistanceViewModel?) {
        
        self.timeInViewModel = timeInViewModel
        
        if timeOutViewModel != nil {
            
            self.timeOutViewModel = timeOutViewModel
        }
        
        layOutCell(forCalendar: forCalendar)
    }
    
    func layOutCell(forCalendar: Bool) {
        
        if let latitude = timeInViewModel?.latitude,
           
           let longitude = timeInViewModel?.longitude {
            
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 300,
                                            longitudinalMeters: 300)
            
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            
            guard let studentName = timeInViewModel?.studentName else {return}
            
            annotation.title = studentName
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                           longitude: longitude)
            
            mapView.addAnnotation(annotation)
        }
        
        guard let time = timeInViewModel?.time else {return}
        
        let attendTime = Date(milliseconds: time).convertToString(dateformat: .time)
        
        labelCellContent.text = "Time in: " + attendTime
        
        labelCellTitle.text = Date(milliseconds: time).convertToString(dateformat: .day)
        
        if forCalendar == false {
            
            labelCellTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
            
            guard let courseName = timeInViewModel?.courseName else {return}
            
            labelCellCourseName.isHidden = false
            
            labelCellCourseName.font = UIFont.boldSystemFont(ofSize: 20.0)
            
            labelCellCourseName.text =  "Class: \(courseName)"
        }
        
        if timeOutViewModel != nil {
            
            mapViewHeight.constant = 0
            
            guard let time = timeOutViewModel?.time else {return}
            
            let leaveTime = Date(milliseconds: time).convertToString(dateformat: .time)
            
            labelCellContent.text = "Time in: " + attendTime + "\n" + "Time out: " + leaveTime
            
            imageViewLocated.isHidden = true
        }
    }
}
