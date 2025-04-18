//
//  FBStackView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 7.07.23.
//

import UIKit

class FloatingButtonStackView: BasicStackView {
    
    private var fabSecondaryButtons: [FloatingButtonSecondItem] = [FloatingButtonSecondItem]()
    private var secondaryButtons: [UIView] = [UIView]()
    private var secondaryViews: [UIView] = [UIView]()
    
    override init() {
        super.init()
        configureStackView()
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureStackView() {
        distribution = .fill
        axis = .vertical
        alignment = .trailing
        spacing = 12
        clipsToBounds = true
    }
    
    
    private func configureSecondaryButtons() {
        for secondary in fabSecondaryButtons {
            let secondaryView = secondary
            secondaryViews.append(secondaryView)
        }
        setSecondaryButtonsArray()
    }
    
    
    private func setSecondaryButtonsArray() {
        for view in secondaryViews {
            secondaryButtons.append(view)
        }
    }
}


// MARK: - Public methods
extension FloatingButtonStackView {
    func addSecondaryButtonWith(component: FloatingButtonSecondItem) {
        fabSecondaryButtons.append(component)
    }
    
    func setFABButton() {
        configureSecondaryButtons()
    }
    
    
    func showButtons() {
        guard let view = secondaryButtons.last else {
            setSecondaryButtonsArray()
            return
        }
        
        secondaryButtons.removeLast()
        
        addArrangedSubview(view)
        
        view.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                UIView.animate(withDuration: 0.075, animations: {
                    view.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                }) { finished in
                    UIView.animate(withDuration: 0.03, animations: {
                        view.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
                    }) { finished in
                        UIView.animate(withDuration: 0.075, animations: {
                            view.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                        }) { finished in
                            self.showButtons()
                        }
                    }
                }
            }
    
    
    func dismissButtons() {
        guard let view = secondaryButtons.last else {
            setSecondaryButtonsArray()
            return
        }
        
        secondaryButtons.removeLast()
        
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }) { finished in
            view.removeFromSuperview()
            self.dismissButtons()
        }
    }
}
