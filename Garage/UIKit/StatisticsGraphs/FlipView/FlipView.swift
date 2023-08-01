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
    
    private(set) lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = 2
        page.currentPage = 0
        page.pageIndicatorTintColor = AppColors.background
        page.currentPageIndicatorTintColor = .lightGray
        return page
    }()
    
    var isRight = false
    
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
        addSubview(pageControl)
        scrollableStack.addArrangedSubviews([barChart, pieChart])
        addSubview(yearBarStack)
    }
    
    private func makeConstraints() {
        scrollableStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(scrollableStack.snp.bottom)
        }
        
        yearBarStack.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.viewModel = vm
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
                    font: .custom(size: 16, weight: .semibold),
                    secondary: "\(dataEntry.map({$0.value}).reduce(0, +))",
                    secondaryFont: .custom(size: 18, weight: .bold),
                    lineSpacing: 2)
            }
            .store(in: &cancellables)
        
        vm.changePeriodSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                switch self?.pageControl.currentPage {
                    case 0:
                        self?.barChart.barChartView.highlightValue(nil)
                        self?.barChart.barChartView.animate(xAxisDuration: 0.3, yAxisDuration: 0.4)
                    case 1:
                        self?.pieChart.pieChartView.highlightValue(nil)
                        self?.pieChart.pieChartView.animate(xAxisDuration: 0.3, yAxisDuration: 0.4)
                    default: break
                }
            }
            .store(in: &cancellables)
    }
}

extension FlipView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x, scrollView.contentSize.height)
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        viewModel?.pageIndex = Int(pageNumber)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let contentSize = scrollView.contentSize.width / 2
        if !decelerate {
            if scrollView.contentOffset.x > 0, !isRight {
                scrollView.setContentOffset(CGPoint(x: contentSize, y: 0), animated: true)
                isRight = true
            } else if scrollView.contentOffset.x < contentSize, isRight {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                isRight = false
            }
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
            viewModel?.pageIndex = Int(pageNumber)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.width / 2
        
        if scrollView.contentOffset.x > 0, !isRight {
            scrollView.setContentOffset(CGPoint(x: contentSize, y: 0), animated: true)
            isRight = true
        } else if scrollView.contentOffset.x < contentSize, isRight {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            isRight = false
        }
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        viewModel?.pageIndex = Int(pageNumber)
    }
}
