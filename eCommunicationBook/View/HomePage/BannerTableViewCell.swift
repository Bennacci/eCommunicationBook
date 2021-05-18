//
//  BannerTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell, UIScrollViewDelegate {
  
  
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    print("Called")
  }
  
  @IBOutlet weak var bannerView: BannerView!
  
  let btnImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
  // swiftlint:disable line_length
  var bannerDatas: [BannerData] = [BannerData(id: 0000, picture: "https://images.unsplash.com/photo-1543519820-59db1a975c8e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1367&q=80", story: "Good Morning"),
                                   BannerData(id: 0001, picture: "https://images.unsplash.com/photo-1620369382852-f43cc7127f29?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2850&q=80", story: "Good Evening"),
                                   BannerData(id: 0002, picture: "https://images.unsplash.com/photo-1503442862980-50ccb3f1d085?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80", story: "Good Night")]
  // swiftlint:enable line_length
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

extension BannerTableViewCell {
  
  func setupTimer() {
    bannerView.timer = Timer.scheduledTimer(timeInterval: 4,
                                            target: self,
                                            selector: #selector(timeChanged),
                                            userInfo: nil,
                                            repeats: true)
    RunLoop.current.add(bannerView.timer, forMode: RunLoop.Mode.common)
  }
  // time 事件
  @objc func timeChanged() {
    bannerView.currentIndex += 1
    // 更新圖片+scrollView
    bannerView.reloadImage()
  }
  
  func setBannerView() {
    for index in 0 ..< bannerDatas.count {
      bannerView.imageArray.append(bannerDatas[index].picture)
      bannerView.sloganArray.append(bannerDatas[index].story)
    }
    self.addSubview(self.bannerView.scrollView)
    self.addSubview(self.bannerView.pageControl)
    setupTimer()
  }
}


class BannerView: UIView, UIScrollViewDelegate {
  
  let width = UIScreen.main.bounds.size.width
  
  var currentIndex: NSInteger = 0
  
  var imageArray = [String]()
  
  var sloganArray = [String]()
  
  var timer = Timer()
  
  var leftImageView = UIImageView()
  
  var rightImageView = UIImageView()
  
  var currentImageView = UIImageView()
  
  var leftLabel = UILabel()
  
  var currentLabel = UILabel()
  
  var rightLabel = UILabel()
  
  lazy var scrollView: UIScrollView = {
    
    let scrollView = UIScrollView()
    
    scrollView.showsHorizontalScrollIndicator = false
    
    scrollView.contentSize = CGSize(width: width * 3, height: 150)
    
    scrollView.contentOffset = CGPoint(x: width, y: 0)
    
    scrollView.isPagingEnabled = true
    
    scrollView.frame = CGRect(x: 0, y: 0, width: width, height: 150)
    
    rightImageView.frame = CGRect(x: width * 2, y: 0, width: width, height: 150)
    setLabel(label: rightLabel, index: 2)
    
    currentImageView.frame = CGRect(x: width * 1, y: 0, width: width, height: 150)
    setLabel(label: currentLabel, index: 1)
    
    leftImageView.frame = CGRect(x: width * 0, y: 0, width: width, height: 150)
    setLabel(label: leftLabel, index: 0)
    
    scrollView.addSubview(rightImageView)
    scrollView.addSubview(rightLabel)
    
    scrollView.addSubview(currentImageView)
    scrollView.addSubview(currentLabel)
    
    scrollView.addSubview(leftImageView)
    scrollView.addSubview(leftLabel)
    
    scrollView.contentMode = .scaleAspectFill
    scrollView.clipsToBounds = true
    
    //    scrollView.delegate = self
    
    return scrollView
  }()
  
  // 下方小圓點
  lazy var pageControl: UIPageControl = {
    
    let pageControl = UIPageControl()
    
    pageControl.frame = CGRect(x: 0, y: scrollView.frame.maxY-20, width: width, height: 20)
    
    pageControl.backgroundColor = UIColor.clear
    
    // 小圓點選取時顏色
    pageControl.currentPageIndicatorTintColor = UIColor.init(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    // 小圓點未選取顏色
    pageControl.pageIndicatorTintColor = UIColor.init(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
    
    pageControl.numberOfPages = imageArray.count
    
    pageControl.currentPage = 0
    
    return pageControl
  }()
  
  func reloadImage() {
    
    var leftIndex = 0
    
    var rightIndex = 2
    
    let imagecount = imageArray.count
    
    if imagecount != 0 {
      currentIndex = currentIndex % imagecount
      
      scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
      
      pageControl.currentPage = (currentIndex - 1 + imagecount) % imagecount // 防止越界
      
      leftIndex = (currentIndex - 1 + imagecount) % imagecount // 防止越界
      
      rightIndex = (currentIndex + 1) % imageArray.count
      
      rightImageView.loadImage(imageArray[leftIndex])
      rightImageView.contentMode = .scaleAspectFill
      rightLabel.text = sloganArray[leftIndex]
      
      currentImageView.loadImage(imageArray[currentIndex])
      currentImageView.contentMode = .scaleAspectFill
      currentLabel.text = sloganArray[currentIndex]
      
      leftImageView.loadImage(imageArray[rightIndex])
      leftImageView.contentMode = .scaleAspectFill
      leftLabel.text = sloganArray[leftIndex]
    }
  }
  
  func setLabel(label: UILabel, index: CGFloat) {
    
    label.frame = CGRect(x: width * index + 21, y: 70, width: width, height: 70)
    
    label.font = UIFont(name: label.font.fontName, size: 22)
    
    label.textColor = UIColor.B1
    
    label.textAlignment = .left
    
    label.numberOfLines = 0
    
    setShadowForLabel(label: label)
  }
  
  func setShadowForLabel(label: UILabel) {
    
    label.layer.shadowColor = UIColor.white.cgColor
    
    label.layer.shadowRadius = 5.0
    
    label.layer.shadowOpacity = 1.0
    
    label.layer.shadowOffset = CGSize(width: 2, height: 2)
    
    label.layer.masksToBounds = false
  }
}
