//
//  LPCommunicationCornerTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/27.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class LPCommunicationCornerTableViewCell: UITableViewCell {
  
  @IBOutlet weak var textViewCommunicationCorner: UITextView!
  var viewModel: StudentLessonRecordViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUp(viewModel: StudentLessonRecordViewModel) {
      self.viewModel = viewModel
      layOutCell()
    }


    func layOutCell() {
//      guard let note = viewModel?.note else { return }
      if viewModel?.note != nil {
        textViewCommunicationCorner.text = viewModel?.note
        textViewCommunicationCorner.textColor = .black
      } else {
        textViewCommunicationCorner.text = "type message..."
        textViewCommunicationCorner.textColor = .lightGray
      }
    }
}
