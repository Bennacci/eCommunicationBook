//
//  ServiceCollectionViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import ChameleonFramework

class ServiceCollectionViewCell: UICollectionViewCell {
    
    var viewModel: ServiceGroup?
    
    @IBOutlet weak var viewServiceBackground: UIView!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewServiceIcon: UIImageView!
    
    @IBOutlet weak var labelServiceName: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    func setUp(viewModel: ServiceGroup, indexPath: IndexPath, hot: Bool) {

        self.viewModel = viewModel

        layOutCell(indexPath: indexPath, hot: hot)
    }
    
    func layOutCell(indexPath: IndexPath, hot: Bool) {

        if hot == true {
            
            labelServiceName.text = self.viewModel?.items[0][indexPath.item].title

            imageViewServiceIcon.image = self.viewModel?.items[0][indexPath.item].image
            
            switch self.viewModel?.items[0][indexPath.item].title {

            case TeacherSeviceItem.writeStudentLessonRecord.title:

                viewServiceBackground.backgroundColor = UIColor.AndroidGreen

            case TeacherSeviceItem.writeLessonPlan.title:

                viewServiceBackground.backgroundColor = UIColor.MinionYellow

            case TeacherSeviceItem.writeStudentTimeInAndOut.title:

                viewServiceBackground.backgroundColor = UIColor.Pumpkin

            case TeacherSeviceItem.attendanceSheet.title:

                viewServiceBackground.backgroundColor = UIColor.CyanProcess

            case ParentSeviceItem.checkStudentTimeInAndOut.title:

                viewServiceBackground.backgroundColor = UIColor.CyanProcess

            default:

                viewServiceBackground.backgroundColor = .gray
            }
            
        } else {

            if let count = self.viewModel?.items[1].count {
                
                if count > indexPath.item {

                    labelServiceName.text = self.viewModel?.items[1][indexPath.item].title

                    imageViewServiceIcon.image = self.viewModel?.items[1][indexPath.item].image
                    
                } else {
                    
                    labelServiceName.text = self.viewModel?.items[2][indexPath.item - count].title

                    imageViewServiceIcon.image = self.viewModel?.items[2][indexPath.item - count].image
                }
            }
        }
    }
}
