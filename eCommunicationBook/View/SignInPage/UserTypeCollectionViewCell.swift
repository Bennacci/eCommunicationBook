//
//  UserTypeCollectionViewCell.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/24.
//  Copyright © 2021 TKY co. All rights reserved.
//


import UIKit
import CollectionViewPagingLayout
import Lottie

class UserTypeCollectionViewCell: UICollectionViewCell {
    
    private var animationView: AnimationView?
    
    var titles = ["Parent", "Teacher"]
    
    var titlesDescription = [String.empty, String.empty]
    
    var backGroundColor = [UIColor.CyanProcess, UIColor.Pumpkin]
    
    var lotties = ["parentLottie", "teacherLottie"]
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var viewContinueButtonBackground: UIView!

    @IBOutlet private weak var viewUserTypeLottieContainer: UIView!
    
    @IBOutlet private weak var viewUserTypeLottieBackground: UIView!
    
    @IBOutlet private weak var imageViewUserType: UIImageView!
    
    @IBOutlet private weak var labelTitel: UILabel!
    
    @IBOutlet private weak var labelDescription: UILabel!
        
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        setupViews()
    }
        
    private func setupViews() {
        
        addShadow(to: viewUserTypeLottieContainer)
       
        addShadow(to: viewUserTypeLottieBackground)
        
        addShadow(to: viewContinueButtonBackground)
        
        clipsToBounds = false
        
        contentView.clipsToBounds = false
        
        labelTitel.font = .systemFont(ofSize: 27, weight: .bold)
        
        labelDescription.font = .systemFont(ofSize: 16, weight: .regular)
        
        labelDescription.textColor = .gray
        
        continueButton.imageEdgeInsets = UIEdgeInsets(top: -15, left: -20, bottom: -15, right: -20)
    }
    
    private func addShadow(to view: UIView) {
       
        view.layer.cornerRadius = 15
        
        view.layer.shadowOffset = .init(width: 0, height: 0.5)
        
        view.layer.shadowOpacity = 0.15
        
        view.layer.shadowRadius = 7
    }
    
    func setUpCell(index: Int) {
        
        viewUserTypeLottieBackground.backgroundColor = backGroundColor[index]
      
        viewUserTypeLottieBackground.layer.shadowColor = backGroundColor[index]?.cgColor
        
        viewContinueButtonBackground.backgroundColor = backGroundColor[index]
        
        labelTitel.text = titles[index]
        
        labelDescription.text = titlesDescription[index]
        
        addLottie(index: index)
    }
    
    private func addLottie(index: Int) {
        
        animationView = .init(name: lotties[index])
        
        animationView!.frame = imageViewUserType.bounds
        
        animationView!.contentMode = .scaleAspectFit
        
        animationView!.loopMode = .loop
        
        animationView!.animationSpeed = 0.5
        
        imageViewUserType.addSubview(animationView!)
        
        imageViewUserType.layoutIfNeeded()
        
        animationView!.play()
    }
}

extension UserTypeCollectionViewCell: TransformableView {
    
    func transform(progress: CGFloat) {
        
        transformCardView(progress: progress)
        
        transformPriceTagView(progress: progress)
        
        let normalTransform = CGAffineTransform(translationX: bounds.width * progress, y: 0)
        
        labelTitel.transform = normalTransform
        
        labelDescription.transform = normalTransform
    }
    
    private func transformPriceTagView(progress: CGFloat) {
        
        let angle = .pi * progress
        
        var transform = CATransform3DIdentity
        
        transform.m34 = -0.008
        
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        
        viewContinueButtonBackground.layer.transform = transform
     
        viewContinueButtonBackground.alpha = abs(progress) > 0.5 ? 0 : 1
    }
    
    private func transformCardView(progress: CGFloat) {
        
        let translationX: CGFloat = bounds.width * progress
        
        let imageScale = 1 - abs(0.5 * progress)
       
        let imageViewUserTypeHeight = imageViewUserType.frame.height
        
        imageViewUserType.transform = CGAffineTransform(translationX: translationX,
                                                        y: progress * imageViewUserTypeHeight / 8)
            .scaledBy(x: imageScale, y: imageScale)
        
        let cardBackgroundScale = 1 - abs(0.3 * progress)
        
        viewUserTypeLottieBackground.transform = CGAffineTransform(translationX: translationX / 1.55, y: 0)
            .scaledBy(x: cardBackgroundScale, y: cardBackgroundScale)
        
        var transform = CATransform3DIdentity
        
        if progress < 0 {
        
            let angle = max(0 - abs(-CGFloat.pi / 3 * progress), -CGFloat.pi / 3)
            
            transform.m34 = -0.011
            
            transform = CATransform3DRotate(transform, angle, 0, 1, 1)
        
        } else {
        
            let angle = max(0 - abs(-CGFloat.pi / 8 * progress), -CGFloat.pi / 8)
            
            transform.m34 = 0.002
            
            transform.m41 = bounds.width * 0.093 * progress
            
            transform = CATransform3DRotate(transform, angle, 0, 1, -0.1)
        }
        
        viewUserTypeLottieContainer.layer.transform = transform
    }
}
