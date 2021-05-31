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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  func setup(viewModel: CourseViewModel) {
      self.viewModel = viewModel
      layoutCell()
  }
  // swiftlint:disable line_length
  func layoutCell() {
    labelCourseName.text = viewModel?.name
    imageViewCourse.loadImage("https://firebasestorage.googleapis.com/v0/b/ecommunicationbook.appspot.com/o/StudentLessonRecordImages%2F2B331657-0F3B-4EB9-96DA-EA60B1A2FB7B.jpg?alt=media&token=05ecb4a2-db75-4bc2-bf32-43e87e70c81f")
  }
    // swiftlint:enable line_length
}
