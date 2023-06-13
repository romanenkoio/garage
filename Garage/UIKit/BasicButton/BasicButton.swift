//
//  BasicButton.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 18.05.23.
//

import UIKit
import Combine
import SnapKit

enum ButtonStyle {
    case primary
    case secondary
}

class BasicButton: UIButton {
    var cancellables: Set<AnyCancellable> = []
    
    private var actionCancellable: AnyCancellable? {
            didSet { oldValue?.cancel() }
    }
    
    override var isHighlighted: Bool {
        didSet {
            setStyle(for: !isHighlighted)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            setStyle(for: isEnabled)
        }
    }
    
    private var style: ButtonStyle? {
        didSet { setButtonColor() }
    }
        
    init() {
        super .init(frame: .zero)
        layer.cornerRadius = 27
        tintColor = .lightGray
        titleLabel?.font = .custom(size: 15, weight: .medium)
        translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.width.equalTo(242)
        }
    }
    
    private func setButtonColor() {
        switch style {
            case .primary:
                backgroundColor = .primaryPink
                setTitleColor(.white, for: .normal)
            case .secondary:
                backgroundColor = .primaryGray
                setTitleColor(.primaryPink, for: .normal)
            case .none:
                backgroundColor = .additionalRed
        }
    }
    
    private func setStyle(for value: Bool) {
        switch style {
            case .primary:
                backgroundColor = value ? .primaryPink : .secondaryPink
            case .secondary:
                backgroundColor = value ? .primaryGray : .secondaryGray
            case .none:
                backgroundColor = .additionalRed
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        vm.$style
            .sink { [weak self] value in self?.style = value }
            .store(in: &cancellables)
        
        vm.$title
            .sink {[weak self] value in self?.setTitle(value, for: .normal) }
            .store(in: &cancellables)
        
        vm.$action
            .sink { [weak self] action in
                guard let self else { return }
                self.actionCancellable = nil
                guard let action else { return }
                self.actionCancellable = self.publisher(for: action.event).sink(receiveValue: { _ in action() })
            }
            .store(in: &cancellables)
        
        vm.$isEnabled
            .sink { [weak self] value in self?.isEnabled = value }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
