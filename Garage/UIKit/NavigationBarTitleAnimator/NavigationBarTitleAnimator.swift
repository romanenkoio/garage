//
//  NavigationBarTitleAnimator.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 24.07.23.
//

import UIKit

class NavigationBarTitleAnimator: UIView {
    private var label = UILabel()
    var changedTitle: String = "" {
        didSet {
            label.text = changedTitle
        }
    }
    
    var defaultTitle: String = "" {
        didSet {
            label.text = defaultTitle
            label.textColor = AppColors.navbarTitle
            label.textAlignment = .center
            label.font = UIFont.custom(size: 16, weight: .bold)
            setNeedsLayout()
        }
    }
    
    var didChangeTitle = false
    let animateUp: CATransition = {
        let animation = CATransition()
        animation.duration = 0.15
        animation.type = .push
        animation.subtype = .fromTop
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }()
    
    let animateDown: CATransition = {
        let animation = CATransition()
        animation.duration = 0.15
        animation.type = .push
        animation.subtype = .fromBottom
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = self.frame
        addSubview(label)
        clipsToBounds = true
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
