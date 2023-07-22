//
//  BasicLabel.swift
//  Logogo
//
//  Created by Illia Romanenko on 20.05.23.
//

import UIKit
import Combine

class BasicLabel: UILabel {
    
    var cancellables: Set<AnyCancellable> = []

    var textInsets: UIEdgeInsets = .zero {
        didSet { self.invalidateIntrinsicContentSize() }
    }
    
    init(font: UIFont? = .custom(size: 14, weight: .semibold)) {
        super.init(frame: .zero)
        self.initLabel()
        guard let font else { return }
        self.font = font
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initLabel()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLabel()
    }
    
    func initLabel() {
        self.numberOfLines = 0
        self.textColor = .textBlack
    }
    
    override func textRect(forBounds bounds: CGRect,
                           limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard self.textInsets != .zero else {
            return super.textRect(forBounds: bounds,
                                  limitedToNumberOfLines: numberOfLines)
        }
        let insetRect = bounds.inset(by: self.textInsets)
        let textRect = super.textRect(forBounds: insetRect,
                                      limitedToNumberOfLines: self.numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -self.textInsets.top,
                                          left: -self.textInsets.left,
                                          bottom: -self.textInsets.bottom,
                                          right: -self.textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.textInsets))
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.cancellables.removeAll()
        
        vm.$textValue
            .sink { [weak self] textValue in
                switch textValue {
                case .text(let text):
                    guard !text.isEmpty else { return }
                    self?.text = text
                case .attributed(let text):
                    guard !text.string.isEmpty else { return }
                    self?.attributedText = text
                }
            }
            .store(in: &cancellables)
        
        vm.$isHidden
            .sink { [weak self] in self?.isHidden = $0 ?? false }
            .store(in: &cancellables)
        
        vm.$textColor.compactMap().sink { [weak self] in
            self?.textColor = $0
        }
        .store(in: &cancellables)
    }
}

extension BasicLabel {
    static let fieldDescription : BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .left
        label.font = .custom(size: 14, weight: .bold)
        label.textColor = .primaryBlue
        return label
    }()
}
