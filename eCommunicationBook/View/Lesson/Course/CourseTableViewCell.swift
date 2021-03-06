//
//  CourseTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    var viewModel: CourseViewModel?
    
    @IBOutlet weak var labelCourseName: UILabel!
    
    @IBOutlet weak var imageViewCourse: UIImageView!
    
    override func awakeFromNib() {

        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setup(viewModel: CourseViewModel) {
        
        self.viewModel = viewModel
        
        layoutCell()
    }
    
    func layoutCell() {
        
        labelCourseName.text = viewModel?.name
        
        if let imageURL = viewModel?.image {
            
            imageViewCourse.loadImage(imageURL)
        }
    }
}
