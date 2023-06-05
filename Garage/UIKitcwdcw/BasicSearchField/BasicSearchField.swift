//
//  BasicSearchField.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 22.05.23.
//

import Foundation
import UIKit
import Combine

class BasicSearchField: BasicTextField {
    private(set) weak var viewModel: ViewModel?
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "magnifyingglass")
        configuration.imagePadding = -20
        button.configuration = configuration
        button.tintColor = .gray
        button.addTarget(self, action: #selector(becomeFirstResponder), for: .touchUpInside)
        button.frame = CGRect(
            x: self.frame.size.width - 25,
            y: 5,
            width: 25,
            height: 25
        )
        return button
    }()
    
    override init() {
        super .init()
        self.rightView = searchButton
        self.rightViewMode = .always
        self.addTarget(
            self,
            action: #selector(textDidChange(field: )),
            for: .editingChanged
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(_ vm: BasicSearchField.ViewModel) {
        self.viewModel = vm
        vm.$placeholder.sink { [weak self] value in
            guard let value,
                  let self else { return }
            self.attributedPlaceholder = value.attributedString(
                font: .custom(size: 17, weight: .medium),
                textColor: self.isEnabled ? .textGray : .textLightGray.withAlphaComponent(0.2)
            )
        }
        .store(in: &cancellables)
    }
    
    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        
        if didBecomeFirstResponder {
            searchButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            searchButton.addTarget(self, action: #selector(closeSearchField), for: .touchUpInside)
        }
        return didBecomeFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        
        if didResignFirstResponder {
            searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            searchButton.addTarget(self, action: #selector(becomeFirstResponder), for: .touchUpInside)
            viewModel?.сloseSearchSubject.send()
        }
        return didResignFirstResponder
    }
    
    @objc private func closeSearchField() {
        text = nil
        _ = resignFirstResponder()
        timer.upstream.connect().cancel()
    }
    
    override func textDidChange(field: UITextField) {
            timer
                .sink {[weak self] _ in
                    if self?.viewModel?.text != self?.text {
                        self?.viewModel?.text = field.text.wrapped
                    } else {
                        self?.timer.upstream.connect().cancel()
                    }
                }
                .store(in: &cancellables)
    }
}
