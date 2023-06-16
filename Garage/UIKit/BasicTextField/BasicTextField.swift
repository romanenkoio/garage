//
//  TextField.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 17.05.23.
//

import UIKit
import Combine
import SnapKit

class BasicTextField: UITextField {
    var cancellables: Set<AnyCancellable> = []
    
    private var actionCancellable: AnyCancellable? {
            didSet { oldValue?.cancel() }
        }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    private(set) weak var vm: ViewModel?
    
    init() {
        super .init(frame: .zero)
        layer.cornerRadius = 12
        layer.borderColor = UIColor.secondaryGray.cgColor
        backgroundColor = .clear
        layer.borderWidth = 1
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 35))
        leftViewMode = .always
        font = .custom(size: 17, weight: .medium)
        clipsToBounds = true
        self.addTarget(self, action: #selector(textDidChange(field:)), for: .editingDidEnd)
        self.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(vm: BasicTextField.ViewModel) {
        self.vm = vm
        vm.$text
            .sink { [weak self] value in self?.text = value}
            .store(in: &cancellables)
        
        vm.$placeholder.sink { [weak self] value in
            guard let value else { return }
            self?.attributedPlaceholder = value.attributedString(
                font: .custom(size: 17, weight: .medium),
                textColor: self?.isEnabled ?? true ? .textGray : .textLightGray.withAlphaComponent(0.2)
            )
        }
        .store(in: &cancellables)
        
        vm.$isEnabled
            .sink { [weak self] value in
                self?.isEnabled = value
                self?.backgroundColor = value ? .white : .white.withAlphaComponent(0.3)
            }
            .store(in: &cancellables)
        
        vm.$isSecure.sink { [weak self] value in
            self?.isSecureTextEntry = value
            if value {
                self?.enablePasswordToggle()
            }
        }
        .store(in: &cancellables)
    }
    
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
        }

        return didResignFirstResponder
    }
    
    private func setPasswordToggleImage(_ button: UIButton) {
        if isSecureTextEntry {
            button.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            button.setImage(UIImage(named: "closedEye"), for: .normal)
        }
    }
    
    private func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        var configuration = UIButton.Configuration.plain()
        setPasswordToggleImage(button)
        configuration.imagePadding = -20
        button.configuration = configuration
        button.frame = CGRect(
            x: self.frame.size.width - 25,
            y: 5,
            width: 25,
            height: 25
        )
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    
    @objc private func togglePasswordView(_ sender: UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender)
    }
    
    @objc func textDidChange(field: UITextField) {
        self.vm?.text = field.text.wrapped
    }
}
