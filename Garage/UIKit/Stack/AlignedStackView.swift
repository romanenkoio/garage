//
//  AlignedStackView.swift
//  BSB-Mobile
//
//  Created by Alexey Oshevnev on 02.02.2023.
//

import Foundation
import UIKit

class AlignedStackView: BasicStackView {

    // MARK: - subtypes

    enum VersaAlignment {
        case fill
        case leading
        case top
        case firstBaseline
        case center
        case trailing
        case bottom
        case lastBaseline

        var rawValue: UIStackView.Alignment {
            switch self {
            case .fill: return .fill
            case .leading: return .leading
            case .top: return .top
            case .firstBaseline: return .firstBaseline
            case .center: return .center
            case .trailing: return .trailing
            case .bottom: return .bottom
            case .lastBaseline: return .lastBaseline
            }
        }
    }

    // MARK: - subviews

    private(set) lazy var contentStackView: BasicStackView = {
        let view = BasicStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 0
        return view
    }()

    // MARK: - properties

    override var axis: NSLayoutConstraint.Axis {
        get { contentStackView.axis }
        set { contentStackView.axis = newValue }
    }

    override var alignment: Alignment {
        get { contentStackView.alignment }
        set { contentStackView.alignment = newValue }
    }

    var versaAlignment: VersaAlignment = .fill {
        didSet {
            switch versaAlignment {
            case .top, .bottom, .firstBaseline, .lastBaseline:
                super.axis = .horizontal
            case .leading, .trailing:
                super.axis = .vertical
            default:
                break
            }
            super.alignment = versaAlignment.rawValue
        }
    }

    override var distribution: Distribution {
        get { contentStackView.distribution }
        set { contentStackView.distribution = newValue }
    }

    override var spacing: CGFloat {
        get { contentStackView.spacing }
        set { contentStackView.spacing = newValue }
    }

    // MARK: - initialization

    override func initView() {
        super.initView()

        super.axis = .vertical
        super.alignment = .fill
        super.distribution = .fill

        super.addArrangedSubview(contentStackView)
    }

    // MARK: - overrides

    override var arrangedSubviews: [UIView] {
        contentStackView.arrangedSubviews
    }

    override func addArrangedSubview(_ view: UIView) {
        contentStackView.addArrangedSubview(view)
    }

    override func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
        contentStackView.insertArrangedSubview(view, at: stackIndex)
    }

    override func removeArrangedSubview(_ view: UIView) {
        contentStackView.removeArrangedSubview(view)
    }

    override func customSpacing(after arrangedSubview: UIView) -> CGFloat {
        contentStackView.customSpacing(after: arrangedSubview)
    }

    override func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        contentStackView.setCustomSpacing(spacing, after: arrangedSubview)
    }

}
