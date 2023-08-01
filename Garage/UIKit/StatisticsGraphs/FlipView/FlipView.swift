//
//  FlipView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 30.07.23.
//

import Foundation
import UIKit

class FlipView: BasicView {
    private(set) lazy var barChart = BarChart()
    private(set) lazy var pieChart = PieChart()
    
    private(set) lazy var scrollableStack = {
        let stack = ScrollableStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.scrollView.delegate = self
        return stack
    }()
    
    private(set) lazy var yearBarStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.spacing = 5
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.contentInset = UIEdgeInsets(horizontal: 16)
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
        scrollableStack.addArrangedSubviews([barChart, pieChart])
        addSubview(yearBarStack)
    }
    
    private func makeConstraints() {
        scrollableStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        yearBarStack.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(scrollableStack.snp.bottom).inset(UIEdgeInsets(top: 10))
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        barChart.setViewModel(vm.barChartVM)
        pieChart.setViewModel(vm.pieChartVM)
        
        vm.barChartVM.$barChartData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.barChart.barChartView.data = data
            }
            .store(in: &cancellables)
        
        vm.$suggestions.sink { [weak self] vms in
            guard !vms.isEmpty else {
                self?.yearBarStack.isHidden = true
                return
            }
            self?.yearBarStack.clearArrangedSubviews()
            vms.forEach { [weak self] vm in
                let view = SuggestionView()
                view.setViewModel(vm)
                self?.yearBarStack.addArrangedSubview(view)
            }
        }
        .store(in: &cancellables)
        
        vm.pieChartVM.$pieChartData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.pieChart.pieChartView.data = data
            }
            .store(in: &cancellables)
        
        vm.pieChartVM.$dataEntries
            .sink {[weak self] dataEntry in
                let textFormatter = TextFormatter()
                self?.pieChart.pieChartView.centerAttributedText = textFormatter.attrinutedLines(
                    main: "Итого",
                    font: .custom(size: 14, weight: .medium),
                    secondary: "\(dataEntry.map({$0.value}).reduce(0, +))",
                    secondaryFont: .custom(size: 16, weight: .semibold),
                    lineSpacing: 2)
            }
            .store(in: &cancellables)
        
        vm.changePeriodSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.pieChart.pieChartView.highlightValue(nil)
                self?.pieChart.pieChartView.animate(xAxisDuration: 0.3, yAxisDuration: 0.4)
            }
            .store(in: &cancellables)
    }
}

extension FlipView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x, scrollView.contentSize.height)
    
    }
    
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
}
