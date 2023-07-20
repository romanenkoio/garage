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
    case addImage
    case removeImage
    case basicLightTitle
    case basicDarkTitle
    case popup(color: UIColor? = nil)
    case complete
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
    
    private var style = ButtonStyle.basicLightTitle {
        didSet { setButtonColor() }
    }
        
    private weak var vm: ViewModel?
    
    init() {
        super .init(frame: .zero)
        layer.cornerRadius = 27
        tintColor = .lightGray
        titleLabel?.font = .custom(size: 16, weight: .semibold)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(242)
            
            guard let vm else { return }
            switch vm.style {
            case .popup:
                make.height.equalTo(48)
                self.cornerRadius = 12
            case .complete:
                make.height.equalTo(28)
                self.cornerRadius = 12
                titleLabel?.font = .custom(size: 12, weight: .bold)
            default:
                make.height.equalTo(64)
            }
        }
    }
    
    private func setButtonColor() {
        switch style {
            case .primary:
                backgroundColor = .primaryBlue
                setTitleColor(.white, for: .normal)
            case .secondary:
                backgroundColor = .primaryGray
                setTitleColor(.primaryBlue, for: .normal)
            case .addImage:
                backgroundColor = .primaryGray
                tintColor = .gray
                setImage(UIImage(named: "plus"), for: .normal)
            case .removeImage:
                backgroundColor = .clear
                tintColor = .red
                setImage(UIImage(named: "delete_photo_ic"), for: .normal)
            case .basicLightTitle:
                backgroundColor = .clear
                setTitleColor(.primaryGray, for: .normal)
            case .basicDarkTitle:
                backgroundColor = .clear
                setTitleColor(.textGray, for: .normal)
            case .popup(color: let color):
            setTitleColor(.primaryBlue, for: .normal)
            if let color {
                backgroundColor = color
                setTitleColor(.white, for: .normal)
            }
            case .complete:
                setTitleColor(.white, for: .normal)
        }
    }
    
    private func setStyle(for value: Bool) {
        switch style {
            case .primary:
            backgroundColor = value ? .primaryBlue : .primaryBlue.withAlphaComponent(0.5)
            case .secondary:
                backgroundColor = value ? .primaryGray : .secondaryGray
            case .basicDarkTitle, .basicLightTitle, .removeImage:
                backgroundColor = .clear
            case .popup(let color):
                backgroundColor = color ?? (value ? .primaryGray : .secondaryGray)
            case .complete:
                backgroundColor = UIColor(hexString: "#1C9837")
            case .addImage:
                backgroundColor = value ? .primaryGray : .secondaryGray
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()
        self.vm = vm
        layout()
        
        vm.$isHidden
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    self?.isHidden = value
                }
            }
            .store(in: &cancellables)
            
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
