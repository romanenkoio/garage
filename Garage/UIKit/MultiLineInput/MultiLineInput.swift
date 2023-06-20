//
//  MultiLineInput.swift
//  Garage
//
//  Created by Illia Romanenko on 20.06.23.
//

import UIKit

class MultiLineInput: BasicView {
    
    private lazy var input: UITextView = {
        let input = UITextView()
        input.font = .custom(size: 17, weight: .medium)
        return input
    }()
    
    private lazy var descriptionLabel: BasicLabel = {
        let label = BasicLabel()
        return label
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        return view
    }()
    
    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()

        return didBecomeFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
     
        return didResignFirstResponder
    }

    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func setup() {
        layer.cornerRadius = 12
        layer.borderColor = UIColor.secondaryGray.cgColor
        backgroundColor = .clear
        layer.borderWidth = 1
    }
    
    private func makeLayout() {
        
    }
    
    private func makeConstraint() {
        
    }
    
    func setViewModel(_ vm: ViewModel) {
        
    }
}
