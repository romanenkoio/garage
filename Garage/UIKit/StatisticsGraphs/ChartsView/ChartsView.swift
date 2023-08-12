//
//  ChartsView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 30.07.23.
//

import Foundation
import UIKit

class ChartsView: BasicView {
    private(set) lazy var barChart = BarChart()
    private(set) lazy var pieChart = PieChart()
    lazy var descriptionLabel: BasicLabel = {
        let view = BasicLabel()
        view.textAlignment = .left
        view.font = .custom(size: 24, weight: .bold)
        view.textInsets = .init(top: 10, left: 16)
        view.backgroundColor = .white
        return view
    }()
    
    private(set) lazy var containerView = BasicView()
    
    private(set) lazy var chartsStack = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private(set) lazy var scrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = CGSize(width: chartsStack.frame.width, height: chartsStack.frame.height)
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        scroll.isPagingEnabled = true
        return scroll
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
        addSubview(containerView)
        containerView.addSubview(scrollView)
        scrollView.addSubview(chartsStack)
        chartsStack.addArrangedSubviews([barChart, pieChart])
        containerView.addSubview(pageControl)
        containerView.addSubview(yearBarStack)
        addSubview(descriptionLabel)
        
//        addSubview(scrollView)


//        addSubview(pageControl)
//        addSubview(yearBarStack)
    }
    
    private func makeConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        chartsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(scrollView.snp.height)
        }
        
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom)
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
        
        vm.$pageIndex
            .sink {[weak self] index in
                switch index {
                    case 0:
                        self?.descriptionLabel.setViewModel(vm.barDescriptionLabelVM)
                    case 1:
                        self?.descriptionLabel.setViewModel(vm.pieDescriptionLabelVM)
                    default: break
                }
            }
            .store(in: &cancellables)
    }
}

extension ChartsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x, scrollView.contentSize.height)
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        guard pageNumber.isNaN else {
            pageControl.currentPage = Int(pageNumber)
            viewModel?.pageIndex = Int(pageNumber)
            return
        }
    }
}
