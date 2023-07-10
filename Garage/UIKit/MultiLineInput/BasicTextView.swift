//
//  BasicTextView.swift
//  Garage
//
//  Created by Illia Romanenko on 23.06.23.
//

import UIKit
import Combine

final class BasicTextView: UITextView {
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        super.init(frame: .zero, textContainer: .none)
        self.font = .custom(size: 17, weight: .medium)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.secondaryGray.cgColor
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.contentInset = .init(vertical: 5, horizontal: 18)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) weak var vm: ViewModel?

    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        
        if didBecomeFirstResponder, let text = self.text {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.layer.borderColor = UIColor.primaryBlue.cgColor
                self?.backgroundColor = .secondaryGray
                self?.layer.borderWidth = 1
            }
            self.text?.removeAll()
            insertText(text)
        }
        
        return didBecomeFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        
        if didResignFirstResponder {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.layer.borderColor = UIColor.secondaryGray.cgColor
                self?.backgroundColor = .clear
                self?.layer.borderWidth = 1
            }
            self.vm?.validate()
            self.vm?.checkChanged(vm?.text ?? .empty)
        }

        return didResignFirstResponder
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.vm = vm
        vm.$text.sink { [weak self] text in
            self?.text = text
        }
        .store(in: &cancellables)
    }
}

extension BasicTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.vm?.text = self.text
    }
}
