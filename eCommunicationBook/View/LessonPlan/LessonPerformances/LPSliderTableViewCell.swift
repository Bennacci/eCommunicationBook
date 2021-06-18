//
//  LPSliderTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LPSliderTableViewCell: UITableViewCell {
    
    var viewModel: StudentLessonRecordViewModel?
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var labelSliderTitle: UILabel!
    
    @IBOutlet weak var viewCellContainer: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        slider.isContinuous = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        
        self.slider.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(viewModel: StudentLessonRecordViewModel, indexPath: IndexPath) {
        
        self.viewModel = viewModel
        
        layOutCell(indexPath: indexPath)
    }
    
    func layOutCell(indexPath: IndexPath) {
        
        guard let performances = viewModel?.performances else { return }
        
        slider.value = Float(performances[indexPath.row])
    
        labelSliderTitle.text = viewModel?.performancesItem[indexPath.row]
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.viewCellContainer)
        
        let positionOfSlider: CGPoint = slider.frame.origin
        
        let widthOfSlider: CGFloat = slider.frame.size.width
        
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider)
        
        slider.setValue(Float(Int(newValue)), animated: true)
    }
}
