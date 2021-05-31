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
  
  @IBOutlet weak var labelExistanceStat: UILabel!
  
  @IBOutlet weak var labelAttandance: UILabel!
    
  @IBOutlet weak var imageViewLocated: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setUp(timeInViewModel: StudentExistanceViewModel, timeOutViewModel: StudentExistanceViewModel?) {
    self.timeInViewModel = timeInViewModel
    if timeOutViewModel != nil {
      self.timeOutViewModel = timeOutViewModel
    }
    layOutCell()
  }
  
  func layOutCell() {
    if let latitude = timeInViewModel?.latitude,
      let longitude = timeInViewModel?.longitude {
      let location = CLLocation(latitude: latitude, longitude: longitude)
      let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
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
    
    labelAttandance.text = "Time in: " + attendTime
    
    guard let studentName = timeInViewModel?.studentName else {return}
    labelExistanceStat.text = "\(studentName) is still at school."
    
    if timeOutViewModel != nil {
      
      guard let time = timeInViewModel?.time else {return}
      labelExistanceStat.text = "\(studentName) has left school."
            
      let leaveTime = Date(milliseconds: time).convertToString(dateformat: .time)
      
      labelAttandance.text = "Time in: " + attendTime + "\n" + "Time out: " + leaveTime
      
      imageViewLocated.tintColor = .gray
    }
  }
  
}
