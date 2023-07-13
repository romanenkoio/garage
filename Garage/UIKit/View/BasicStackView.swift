//
//  BasicStackView.swift
//  Logogo
//
//  Created by Illia Romanenko on 19.05.23.
//

import Combine
import UIKit

class BasicStackView: UIStackView {

    // MARK: - properties
    

    var cancellables: Set<AnyCancellable> = []

    var edgeInsets: UIEdgeInsets = .zero {
        didSet {
            self.updateLayoutMargins()
            self.setNeedsLayout()
        }
    }

    var paddingInsets: UIEdgeInsets = .zero {
        didSet { self.updateLayoutMargins() }
    }

    override var alignmentRectInsets: UIEdgeInsets {
        .init(top: -self.edgeInsets.top,
              left: -self.edgeInsets.left,
              bottom: -self.edgeInsets.bottom,
              right: -self.edgeInsets.right)
    }

    override var cornerRadius: CGFloat {
        get {
            if #available(iOS 14, *) {
                return super.cornerRadius
            } else {
                return self.backgroundView.cornerRadius
            }
        }
        set {
            if #available(iOS 14, *) {
                super.cornerRadius = newValue
            } else {
                self.backgroundView.cornerRadius = newValue
            }
        }
    }

    override var backgroundColor: UIColor? {
        get {
            if #available(iOS 14, *) {
                return super.backgroundColor
            } else {
                return backgroundView.backgroundColor
            }
        }
        set {
            if #available(iOS 14, *) {
                super.backgroundColor = newValue
            } else {
                backgroundView.backgroundColor = newValue
            }

        }
    }

    // MARK: - subviews

    private lazy var backgroundView: UIView = {
        let view: UIView = .init(frame: bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(view, at: 0)
        return view
    }()

    // MARK: - init

    init() {
        super.init(frame: .zero)
        self.initView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    func initView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 0
    }

    // MARK: - updating

    private func updateLayoutMargins() {
        let insets = UIEdgeInsets(
            top: self.edgeInsets.top + self.paddingInsets.top,
            left: self.edgeInsets.left + self.paddingInsets.left,
            bottom: self.edgeInsets.bottom + self.paddingInsets.bottom,
            right: self.edgeInsets.right + self.paddingInsets.right)
        self.isLayoutMarginsRelativeArrangement = insets != .zero
        self.layoutMargins = insets
    }
}
