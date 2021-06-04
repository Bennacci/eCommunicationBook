//
//  ScanStudentQRCodeViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/29.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import CoreLocation
import SwiftyMenu
import SnapKit

class ScanStudentQRCodeViewController: UIViewController {
  
  var viewModel = ScanStudentQRCodeViewModel()
  
  var hideDropDown = false
  
  @IBOutlet weak var dropDownCourse: SwiftyMenu!
  
  @IBOutlet weak var dropDownLesson: SwiftyMenu!
  
  @IBOutlet weak var middleConstraintTimeIn: NSLayoutConstraint!
  @IBOutlet weak var middleConstraintTimeOut: NSLayoutConstraint!
  @IBOutlet weak var heightConstraintTimeIn: NSLayoutConstraint!
  @IBOutlet weak var heightConstraintTimeOut: NSLayoutConstraint!
  @IBOutlet weak var qrCodeView: UIView!
  @IBOutlet weak var qrCodeMaskView: UIView!
  @IBOutlet weak var labelStudentName: UILabel!
  @IBOutlet weak var labelLocaiton: UILabel!
  
  let captureSession = AVCaptureSession()
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var qrCodeFrameView: UIView?
  let locationManager = CLLocationManager()
  
  
  @IBAction func tapLeaveButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.setNavigationBarHidden(true, animated: true)

  viewModel.wroteInSuccess = {
      LKProgressHUD.showSuccess(text: "Time In Success")
      
    }
    viewModel.wroteOutSuccess = {
      LKProgressHUD.showSuccess(text: "Time Out Success")
    }
    
    viewModel.courseViewModel.bind { [weak self] _ in
      
      self?.setDropDown()
      
    }
    
    viewModel.lessonListChanged = {
      print(self.viewModel.lessonList)
      self.dropDownLesson.items = self.viewModel.lessonList
    }
    
    if hideDropDown == false {
      viewModel.fetchCourse()
    }
    
    startDetectingQRCode()
    startDetectingCurrentLocation()
    addBlurMask()
    //    prepareWindow()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  @IBAction func timeInButtonPress(_ sender: Any) {
    
    viewModel.timeIn = true
    UIView.animate(withDuration: 0.5, animations: { () -> Void in
      self.middleConstraintTimeIn.isActive = true
      self.middleConstraintTimeOut.isActive = false
      self.heightConstraintTimeIn.constant = 200
      self.heightConstraintTimeOut.constant = 0
      
      self.view.layoutIfNeeded()
    })
    
  }
  
  @IBAction func timeOutButtonPress(_ sender: Any) {
    
    viewModel.timeIn = false
    UIView.animate(withDuration: 0.5, animations: { () -> Void in
      self.middleConstraintTimeIn.isActive = false
      self.middleConstraintTimeOut.isActive = true
      self.heightConstraintTimeIn.constant = 0
      self.heightConstraintTimeOut.constant = 200
      
      self.view.layoutIfNeeded()
    })
    
  }
  
  func addBlurMask() {
    
    
    let distanceToEdge: CGFloat = 50.0
    qrCodeMaskView.backgroundColor =  UIColor.black.withAlphaComponent(0.4)
    let maskLayer = CALayer()
    maskLayer.frame = qrCodeMaskView.bounds
    let midSquareleLayer = CAShapeLayer()
    midSquareleLayer.frame = CGRect(x: 0,
                                    y: 0,
                                    width: qrCodeMaskView.frame.size.width,
                                    height: qrCodeMaskView.frame.size.height)
    let finalPath = UIBezierPath(roundedRect:
      CGRect(x: 0, y: 0,
             width: qrCodeMaskView.frame.size.width,
             height: qrCodeMaskView.frame.size.height),
                                 cornerRadius: 0)
    let squarePath = UIBezierPath(roundedRect:
      CGRect(x: distanceToEdge / 2,
             y: (UIScreen.height - 200 - (UIScreen.width - distanceToEdge))/2,
             width: UIScreen.width - distanceToEdge,
             height: UIScreen.width - distanceToEdge),
                                  cornerRadius: 15.0)
    
    finalPath.append(squarePath.reversing())
    midSquareleLayer.path = finalPath.cgPath
    midSquareleLayer.borderColor = UIColor.white.withAlphaComponent(1).cgColor
    midSquareleLayer.borderWidth = 1
    maskLayer.addSublayer(midSquareleLayer)
    
    
    let squareInLinePath = UIBezierPath(roundedRect:
      CGRect(x: (distanceToEdge + 3) / 2,
             y: (UIScreen.height - 200 - (UIScreen.width - (distanceToEdge + 3))) / 2,
             width: UIScreen.width - distanceToEdge - 3,
             height: UIScreen.width - distanceToEdge - 3),
                                        cornerRadius: 15.0)
    
    let shapeLayer = CAShapeLayer()
    
    shapeLayer.path = squareInLinePath.cgPath
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = UIColor.gray.cgColor
    shapeLayer.lineWidth = 4.0
    
    
    let mask = CAShapeLayer()
    let path = UIBezierPath()
    let height = UIScreen.height
    let width = UIScreen.width
    let y1Point = (UIScreen.height + UIScreen.width - 350)/2
    let y2Point = (UIScreen.height - UIScreen.width - 50)/2
    let pts = [
      CGPoint(x: 75, y: 0),
      CGPoint(x: 75, y: height),
      CGPoint(x: 0, y: height),
      CGPoint(x: 0, y: y1Point),
      CGPoint(x: width, y: y1Point),
      CGPoint(x: width, y: height),
      CGPoint(x: width - 75, y: height),
      CGPoint(x: width - 75, y: 0),
      CGPoint(x: width, y: 0),
      CGPoint(x: width, y: y2Point),
      CGPoint(x: 0, y: y2Point)]
    
    path.move(to: CGPoint(x: 0, y: 0))
    
    for index in 0 ..< pts.count {
      path.addLine(to: pts[index])
    }
    path.close()
    mask.path = path.cgPath
    shapeLayer.mask = mask
    
    qrCodeView.layer.addSublayer(shapeLayer)
    
    qrCodeMaskView.layer.mask = maskLayer
  }
  func setDropDown() {
    
    if hideDropDown == true {
      dropDownCourse.isHidden = true
      dropDownLesson.isHidden = true
      return
    }
    // Setup component
    dropDownCourse.delegate = self
    dropDownLesson.delegate = self
    
    dropDownCourse.items = self.viewModel.courseViewModel.value.map({$0.name})
    dropDownLesson.items = self.viewModel.lessonList

    //        dropDown2.items = dropDownOptionsDataSource
    if viewModel.studentExistance.courseName == "" {
      dropDownCourse.placeHolderText = "Please Select Course"
    } else {
      dropDownCourse.placeHolderText = self.viewModel.studentExistance.courseName
    }
    
    if viewModel.studentExistance.courseLesson == 0 {
      dropDownLesson.placeHolderText = "Please Select Lesson"
    } else {
      dropDownLesson.placeHolderText = String(self.viewModel.studentExistance.courseLesson)
    }
    
    dropDownCourse.separatorCharacters = " & "
    //    print(dropDown2.selectedIndecis)
    
    // Support CallBacks
    dropDownCourse.didExpand = {
      print("SwiftyMenu Expanded!")
    }
    
    dropDownCourse.didCollapse = {
      print("SwiftyMenu Collapsed!")
    }
    
    dropDownCourse.didSelectItem = { _, item, index in
      print("\(item) at index: \(index)")
    }
    
    modDropdow(dropDown: dropDownCourse)
    modDropdow(dropDown: dropDownLesson)
  }
  
  func modDropdow(dropDown: SwiftyMenu) {
    // Custom Behavior
    dropDown.scrollingEnabled = true
    dropDown.isMultiSelect = false
    dropDown.hideOptionsWhenSelect = false
    
    // Custom UI
    dropDown.rowHeight = 38
    dropDown.listHeight = 340
    dropDown.borderWidth = 0.8
  
    // Custom Colors
    dropDown.borderColor = .black
    dropDown.itemTextColor = .black
    dropDown.placeHolderColor = .lightGray
    
    dropDown.borderColor = .black
    dropDown.itemTextColor = .black
    dropDown.placeHolderColor = .lightGray

    // Custom Animation
    dropDown.expandingAnimationStyle = .spring(level: .low)
    dropDown.expandingDuration = 0.5
    dropDown.collapsingAnimationStyle = .linear
    dropDown.collapsingDuration = 0.5
  }
  
  
  
  func startDetectingQRCode() {
    
    labelStudentName.text = "No QR code detected"
    
    guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
      print("Failed to get the camera device")
      return
    }
    
    do {
      // 使用前一個裝置物件來取得 AVCaptureDeviceInput 類別的實例
      let input = try AVCaptureDeviceInput(device: captureDevice)
      
      // 在擷取 session 設定輸入裝置
      captureSession.addInput(input)
      
      // 初始化一個 AVCaptureMetadataOutput 物件並將其設定做為擷取 session 的輸出裝置
      let captureMetadataOutput = AVCaptureMetadataOutput()
      captureSession.addOutput(captureMetadataOutput)
      
      // 設定委派並使用預設的調度佇列來執行回呼（call back）
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
      
      // 初始化影片預覽層，並將其作為子層加入 viewPreview 視圖的圖層中
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
      videoPreviewLayer?.frame = qrCodeView.layer.bounds
      qrCodeView.layer.addSublayer(videoPreviewLayer!)
      
      // 開始影片的擷取
      captureSession.startRunning()
      
      qrCodeFrameView = UIView()
      
      if let qrCodeFrameView = qrCodeFrameView {
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        qrCodeView.addSubview(qrCodeFrameView)
        qrCodeView.bringSubviewToFront(qrCodeFrameView)
      }
    } catch {
      // 假如有錯誤產生、單純輸出其狀況不再繼續執行
      print(error)
      return
    }
  }
  func startDetectingCurrentLocation() {
    
    // Ask for Authorisation from the User.
    locationManager.requestAlwaysAuthorization()
    // For use in foreground
    locationManager.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
      locationManager.requestLocation()
    }
  }
  
}

extension ScanStudentQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
  
  func metadataOutput(_ output: AVCaptureMetadataOutput,
                      didOutput metadataObjects: [AVMetadataObject],
                      from connection: AVCaptureConnection) {
    
    // 檢查  metadataObjects 陣列為非空值，它至少需包含一個物件
    if metadataObjects.count == 0 {
      qrCodeFrameView?.frame = CGRect.zero
      labelStudentName.text = "No QR code detected"
      return
    }
    
    // 取得元資料（metadata）物件
    if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
      
      if metadataObj.type == AVMetadataObject.ObjectType.qr {
        // 倘若發現的元資料與 QR code 元資料相同，便更新狀態標籤的文字並設定邊界
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrCodeFrameView?.frame = barCodeObject!.bounds
        
        if metadataObj.stringValue != nil {
          labelStudentName.text = metadataObj.stringValue
          guard let value: String = metadataObj.stringValue else {return}
          viewModel.onScanedAQRCode(info: value)
        }
      }
    } else {return}
  }
}


extension ScanStudentQRCodeViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      print("Found user's location: \(location)")
      guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
      
      labelLocaiton.text = "locations = \(locValue.latitude) \(locValue.longitude)"
      viewModel.onCurrentLocationChanged(latitude: locValue.latitude, longitude: locValue.longitude)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to find user's location: \(error.localizedDescription)")
    labelLocaiton.text = "error"
    
  }
  
  func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
  }
}

// MARK: - SwiftMenuDelegate

extension ScanStudentQRCodeViewController: SwiftyMenuDelegate {
  func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
    if swiftyMenu == dropDownCourse {
      viewModel.onCourseNameChanged(index: index)
      print("Selected item: \(item), at index: \(index)")
    } else {
      viewModel.onCourseLessonChanged(index: index)
    }
    
  }
  
  func swiftyMenu(willExpand swiftyMenu: SwiftyMenu) {
    print("SwiftyMenu willExpand.")
  }
  
  func swiftyMenu(didExpand swiftyMenu: SwiftyMenu) {
    print("SwiftyMenu didExpand.")
  }
  
  func swiftyMenu(willCollapse swiftyMenu: SwiftyMenu) {
    print("SwiftyMenu willCollapse.")
  }
  
  func swiftyMenu(didCollapse swiftyMenu: SwiftyMenu) {
    print("SwiftyMenu didCollapse.")
  }
  
}

// String extension to conform SwiftyMenuDisplayable for defult behavior
extension String: SwiftyMenuDisplayable {
  public var displayableValue: String {
    return self
  }
  
  public var retrievableValue: Any {
    return self
  }
}
