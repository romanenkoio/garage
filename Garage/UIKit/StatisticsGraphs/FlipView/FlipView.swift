//
//  FlipView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 30.07.23.
//

import Foundation
import UIKit

class FlipView: BasicView {
    private lazy var scrollableStack = {
        let stack = ScrollableStackView()
        stack.spacing = 5
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.scrollView.delegate = self
        return stack
    }()
    
    var isRightAfterDragging = false
    var isRightAfterScrollingAnimation = false
    
    var scrollabelSubviews: [BasicView] = .empty
    
    var viewModel: ViewModel?
    
    override init() {
        super.init()
        makeLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(scrollableStack)
    }
    
    private func makeConstraints() {
        scrollableStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addSubviews(_ views: [BasicView], viewFrame: CGRect) {
        self.scrollabelSubviews = views
        scrollableStack.addArrangedSubviews(views)
    }
    
    func setViewModel(_ vm: ViewModel) {
        
    }
}

extension FlipView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentSize = scrollView.contentSize.height
        if !decelerate {
            if scrollView.contentOffset.x > 0, !isRightAfterDragging {
                scrollView.setContentOffset(CGPoint(x: contentSize, y: 0), animated: true)
                isRightAfterDragging = true
            } else if scrollView.contentOffset.x < contentSize, isRightAfterDragging {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                isRightAfterDragging = false
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height
        if scrollView.contentOffset.x > 0, !isRightAfterDragging {
            scrollView.setContentOffset(CGPoint(x: contentSize, y: 0), animated: true)
            isRightAfterDragging = true
        } else if scrollView.contentOffset.x < contentSize, isRightAfterDragging {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            isRightAfterDragging = false
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}
