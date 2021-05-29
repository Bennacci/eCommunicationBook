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

class ScanStudentQRCodeViewController: UIViewController {
  
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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //    self.tabBarController?.tabBar.layer.zPosition = -1
    startDetectingQRCode()
    startDetectingCurrentLocation()
    addBlurMask()
  }
  
  //  override func viewDidDisappear(_ animated: Bool) {
  //    self.tabBarController?.tabBar.layer.zPosition = 0
  ////
  //  }
  
  @IBAction func timeInButtonPress(_ sender: Any) {
    
    UIView.animate(withDuration: 0.5, animations: { () -> Void in
      self.middleConstraintTimeIn.isActive = true
      self.middleConstraintTimeOut.isActive = false
      self.heightConstraintTimeIn.constant = 200
      self.heightConstraintTimeOut.constant = 0
      
      self.view.layoutIfNeeded()
    })
    
  }
  
  @IBAction func timeOutButtonPress(_ sender: Any) {
    
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

    
    
//    let mask = CAShapeLayer()
//    var path = UIBezierPath()
//    mask.fillColor = UIColor.black.cgColor
//    path.move(to: CGPoint(x: 100, y: 100))
//    path.addLine(to: CGPoint(x: 300, y: 100))
//    path.addLine(to: CGPoint(x: 100, y: 600))
//    path.addLine(to: CGPoint(x: 300, y: 600))
//    path.close()
//    mask.path = path.cgPath
//    squareInLinePath.layer.mask = mask
    
    

    
    let shapeLayer = CAShapeLayer()
    
    shapeLayer.path = squareInLinePath.cgPath
//     Change the fill color
    shapeLayer.fillColor = UIColor.clear.cgColor
//     You can change the stroke color
    shapeLayer.strokeColor = UIColor.gray.cgColor
//     You can change the line width
    shapeLayer.lineWidth = 4.0
    
//    view.layer.addSublayer(shapeLayer)
    

    
    let mask = CAShapeLayer()
    let path = UIBezierPath()
//    mask.fillColor = UIColor.black.cgColor
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
    
    
    
    view.layer.addSublayer(shapeLayer)
    
    qrCodeMaskView.layer.mask = maskLayer
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
      
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to find user's location: \(error.localizedDescription)")
    labelLocaiton.text = "error"
    
  }
  
  func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
  }
  
  //  // Below Mehtod will print error if not able to update location.
  //  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
  //      print("Error Location")
  //  }
  //
  //
  //  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  //
  //      //Access the last object from locations to get perfect current location
  //      if let location = locations.last {
  //
  //          let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
  //
  //          geocode(latitude: myLocation.latitude, longitude: myLocation.longitude) { placemark, error in
  //              guard let placemark = placemark, error == nil else { return }
  //              // you should always update your UI in the main thread
  //              DispatchQueue.main.async {
  //                  //  update UI here
  //                  print("address1:", placemark.thoroughfare ?? "")
  //                  print("address2:", placemark.subThoroughfare ?? "")
  //                  print("city:",     placemark.locality ?? "")
  //                  print("state:",    placemark.administrativeArea ?? "")
  //                  print("zip code:", placemark.postalCode ?? "")
  //                  print("country:",  placemark.country ?? "")
  //              }
  //          }
  //      }
  //      manager.stopUpdatingLocation()
  //  }
}





extension AppDelegate: CLLocationManagerDelegate {
  
  func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
  }
  
  // Below Mehtod will print error if not able to update location.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error Location")
  }
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    //Access the last object from locations to get perfect current location
    if let location = locations.last {
      
      let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
      
      geocode(latitude: myLocation.latitude, longitude: myLocation.longitude) { placemark, error in
        guard let placemark = placemark, error == nil else { return }
        // you should always update your UI in the main thread
        DispatchQueue.main.async {
          //  update UI here
          print("address1:", placemark.thoroughfare ?? "")
          print("address2:", placemark.subThoroughfare ?? "")
          print("city:",     placemark.locality ?? "")
          print("state:",    placemark.administrativeArea ?? "")
          print("zip code:", placemark.postalCode ?? "")
          print("country:",  placemark.country ?? "")
        }
      }
    }
    manager.stopUpdatingLocation()
    
  }
}
