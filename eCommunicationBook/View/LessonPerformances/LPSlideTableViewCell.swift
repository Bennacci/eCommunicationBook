//
//  LPSlideTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LPSlideTableViewCell: UITableViewCell {

  var viewModel: LessonPerformancesViewModel?
  
  @IBOutlet weak var slider: UISlider!
  
  @IBOutlet weak var labelSlideTitle: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    slider.isContinuous = true
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
    self.slider.addGestureRecognizer(tapGestureRecognizer)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
  func setUp(viewModel: LessonPerformancesViewModel, indexPath: IndexPath) {
    self.viewModel = viewModel
    layOutCell(indexPath: indexPath)
  }
  
  
  @IBOutlet weak var view: UIView!
  func layOutCell(indexPath: IndexPath) {

    labelSlideTitle.text = viewModel?.performancesItem[indexPath.row]
    
  }
  @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {

    let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)

      let positionOfSlider: CGPoint = slider.frame.origin
      let widthOfSlider: CGFloat = slider.frame.size.width
      let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider)

      slider.setValue(Float(Int(newValue)), animated: true)
  }
}
