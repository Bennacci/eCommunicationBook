//
//  BannerTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    var onTimeChanged: (() -> Void)?
    
    @IBOutlet weak var bannerView: BannerView!
    
    // swiftlint:disable line_length
    var bannerDatas: [BannerData] = [BannerData(id: 0000,
                                                picture: "https://firebasestorage.googleapis.com/v0/b/ecommunicationbook.appspot.com/o/BannerImage%2FmessageImage_1623065314066.jpg?alt=media&token=23179fbe-791c-42ce-a220-453a588a1e3f",
                                                story: "2020 Sumer Camp"),
                                     BannerData(id: 0001,
                                                picture: "https://firebasestorage.googleapis.com/v0/b/ecommunicationbook.appspot.com/o/BannerImage%2FmessageImage_1623065406533.jpg?alt=media&token=0584ffcb-39f5-4090-910b-6727f52b2562",
                                                story: "Summer camp open for registration"),
                                     BannerData(id: 0002,
                                                picture: "https://firebasestorage.googleapis.com/v0/b/ecommunicationbook.appspot.com/o/BannerImage%2FmessageImage_1623065453171.jpg?alt=media&token=4a5d86ca-2ff1-40e4-aa77-6e4e4fee3d68",
                                                story: "2020 Halloween")]
    // swiftlint:enable line_length
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
}

extension BannerTableViewCell {
    
    func setupTimer() {
        
        bannerView.timer.invalidate()

        bannerView.timer = Timer.scheduledTimer(timeInterval: 5,
                                                target: self,
                                                selector: #selector(timeChanged),
                                                userInfo: nil,
                                                repeats: true)
        
        RunLoop.current.add(bannerView.timer, forMode: RunLoop.Mode.common)
    }

    @objc func timeChanged() {
        
        self.onTimeChanged?()
    }
    
    func setBannerView() {
        
        bannerView.imageArray = []
        
        bannerView.sloganArray = []
        
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
        
        scrollView.contentSize = CGSize(width: width * 3, height: 180)
        
        scrollView.contentOffset = CGPoint(x: width, y: 0)
        
        scrollView.isPagingEnabled = true
        
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: 180)
        
        rightImageView.frame = CGRect(x: width * 2, y: 0, width: width, height: 180)
        setLabel(label: rightLabel, index: 2)
        
        currentImageView.frame = CGRect(x: width * 1, y: 0, width: width, height: 180)
        setLabel(label: currentLabel, index: 1)
        
        leftImageView.frame = CGRect(x: width * 0, y: 0, width: width, height: 180)
        setLabel(label: leftLabel, index: 0)
        
        scrollView.addSubview(rightImageView)
        scrollView.addSubview(rightLabel)
        
        scrollView.addSubview(currentImageView)
        scrollView.addSubview(currentLabel)
        
        scrollView.addSubview(leftImageView)
        scrollView.addSubview(leftLabel)
        
        scrollView.contentMode = .scaleAspectFill
        
        scrollView.clipsToBounds = true
                
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        
        let pageControl = UIPageControl()
        
        pageControl.frame = CGRect(x: 0, y: scrollView.frame.maxY-20, width: width, height: 20)
        
        pageControl.backgroundColor = UIColor.clear
        
        // color when selected
        pageControl.currentPageIndicatorTintColor = UIColor.init(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        // color when not selected
        pageControl.pageIndicatorTintColor = UIColor.init(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        
        pageControl.numberOfPages = imageArray.count
        
        pageControl.currentPage = (currentIndex - 1 + imageArray.count) % imageArray.count
        
        return pageControl
    }()
    
    func reloadImage() {
        
        var leftIndex = 0
        
        var rightIndex = 0
        
        let imagecount = imageArray.count
        
        if imagecount != 0 {
            
            currentIndex = currentIndex % imagecount
            
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: true)
                        
            pageControl.currentPage = (currentIndex - 1 + imagecount) % imagecount
            
            leftIndex = (currentIndex - 1 + imagecount) % imagecount
            
            rightIndex = (currentIndex + 1) % imagecount
            
            rightImageView.loadImage(imageArray[rightIndex])
            rightImageView.contentMode = .scaleAspectFill
            rightLabel.text = sloganArray[rightIndex]
            
            currentImageView.loadImage(imageArray[currentIndex])
            currentImageView.contentMode = .scaleAspectFill
            currentLabel.text = sloganArray[currentIndex]
            
            leftImageView.loadImage(imageArray[rightIndex])
            leftImageView.contentMode = .scaleAspectFill
            leftLabel.text = sloganArray[leftIndex]
        }
    }
    
    func setLabel(label: UILabel, index: CGFloat) {
        
        label.frame = CGRect(x: width * index + 21, y: 120, width: width, height: 30)
        
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        label.textColor = .white
        
        label.textAlignment = .left
        
        label.numberOfLines = 0
        
        setShadowForLabel(label: label)
    }
    
    func setShadowForLabel(label: UILabel) {
        
        label.layer.shadowColor = UIColor.black.cgColor
        
        label.layer.shadowRadius = 2.0
        
        label.layer.shadowOpacity = 1.0
        
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        label.layer.masksToBounds = true
    }
}
