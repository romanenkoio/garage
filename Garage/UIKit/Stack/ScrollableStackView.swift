//
//  ScrollableStackView.swift
//  BSB-Mobile
//
//  Created by Alexey Oshevnev on 31.01.2023.
//

import UIKit

class ScrollableStackView: BasicStackView {
    // MARK: - subviews

    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.clipsToBounds = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private(set) lazy var alignedStackView: AlignedStackView = {
        let view = AlignedStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.versaAlignment = .fill
        view.distribution = .fill
        view.spacing = 0
        return view
    }()

    // MARK: - properties

    override var axis: NSLayoutConstraint.Axis {
        get {
            alignedStackView.axis
        }
        set {
            alignedStackView.axis = newValue
            setNeedsUpdateConstraints()
        }
    }

    var contentInset: UIEdgeInsets {
        get {
            scrollView.contentInset
        }
        set {
            scrollView.contentInset = newValue
            setNeedsUpdateConstraints()
        }
    }

    override var alignment: Alignment {
        get { alignedStackView.alignment }
        set { alignedStackView.alignment = newValue }
    }

    var versaAlignment: AlignedStackView.VersaAlignment {
        get { alignedStackView.versaAlignment }
        set { alignedStackView.versaAlignment = newValue }
    }

    override var distribution: Distribution {
        get { alignedStackView.distribution }
        set { alignedStackView.distribution = newValue }
    }

    override var spacing: CGFloat {
        get { alignedStackView.spacing }
        set { alignedStackView.spacing = newValue }
    }

    // MARK: - initialization

    override func initView() {
        super.initView()

        super.addArrangedSubview(scrollView)
        scrollView.addSubview(alignedStackView)
    }

    // MARK: - layout

    override func updateConstraints() {
        alignedStackView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview().offset(-contentInset.vertical)

            switch axis {
            case .vertical:
                $0.width.equalToSuperview().offset(-contentInset.horizontal)
            case .horizontal:
                $0.width.greaterThanOrEqualToSuperview().offset(-contentInset.horizontal)
            @unknown default:
                assertionFailure()
                $0.width.equalToSuperview().offset(-contentInset.horizontal)
            }
        }

        super.updateConstraints()
    }

    // MARK: - overrides

    override var arrangedSubviews: [UIView] {
        alignedStackView.arrangedSubviews
    }

    override func addArrangedSubview(_ view: UIView) {
        alignedStackView.addArrangedSubview(view)
    }

    override func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
        alignedStackView.insertArrangedSubview(view, at: stackIndex)
    }

    override func removeArrangedSubview(_ view: UIView) {
        alignedStackView.removeArrangedSubview(view)
    }

    override func customSpacing(after arrangedSubview: UIView) -> CGFloat {
        alignedStackView.customSpacing(after: arrangedSubview)
    }

    override func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        alignedStackView.setCustomSpacing(spacing, after: arrangedSubview)
    }

}
