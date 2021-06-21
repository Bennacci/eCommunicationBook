//
//  NewsTableViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/18.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    var viewModel: EventViewModel?
    
    @IBOutlet weak var imageViewSign: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelContent: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(viewModel: EventViewModel) {
        
        self.viewModel = viewModel
        
        self.layOutCell()
    }
    
    func layOutCell() {
        
        labelTitle.text = viewModel?.eventName
        
        labelContent.text = viewModel?.description
        
        imageViewSign.loadImage(viewModel?.image, placeHolder: UIImage.asset(.communicationBook))
    }
}
