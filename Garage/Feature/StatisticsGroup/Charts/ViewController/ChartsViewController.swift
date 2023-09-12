//
//  StatisticsViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
//  
//

import UIKit

class ChartsViewController: BasicViewController {

    // - UI
    typealias Coordinator = ChartsControllerCoordinator
    typealias Layout = ChartsControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    var coordinator: Coordinator!
    private var layout: Layout!
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCloseButton(side: .left)
        disableScrollView()
        title = "Статистика"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layout.isFirstLayoutSubviews {
            
            layout.maxConstraintConstant = layout.chartsView.frame.size.height
            
            layout.startChartsOrigin = layout.chartsView.frame.origin
        }
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        if let chartsVM = vm.chartsViewVM {
            layout.chartsView.setViewModel(chartsVM)
        }
        
        layout.table.setViewModel(vm.tableVM)
        
        vm.$suggestions
            .sink { [weak self] vms in
                guard !vms.isEmpty else {
                    self?.layout.yearBarStack.isHidden = true
                    return
                }
                self?.layout.yearBarStack.clearArrangedSubviews()
                vms.forEach { [weak self] vm in
                    let view = SuggestionView()
                    view.setViewModel(vm)
                    self?.layout.yearBarStack.addArrangedSubview(view)
                }

            }
            .store(in: &cancellables)
        
        layout.chartsView.barChart.viewModel?.$records
            .sink(receiveValue: {[weak self] barChartRecords in
                guard let self else { return }
                vm.createRecords(from: barChartRecords)
            })
            .store(in: &cancellables)
        
        layout.chartsView.pieChart.viewModel?.$records
            .sink(receiveValue: {[weak self] pieChartRecords in
                guard let self else { return }
                vm.createRecords(from: pieChartRecords)
            })
            .store(in: &cancellables)
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink {[weak self] cells in
                guard let self else { return }
                self.layout.table.reload()
                self.layout.initialContentSizeHeight = layout.table.table.contentSize.height
            }
            .store(in: &cancellables)
    }
    
}

// MARK: -
// MARK: - Configure

extension ChartsViewController {

    private func configureCoordinator() {
        coordinator = ChartsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = ChartsControllerLayoutManager(vc: self)
    }
}

//MARK: - UITableViewDataSource

extension ChartsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let pastRecordCell = tableView.dequeueReusableCell(BasicTableCell<DateHeaderView>.self, for: indexPath) else { return .init() }
            pastRecordCell.mainView.setViewModel(vm.headers[indexPath.section])
            pastRecordCell.selectionStyle = .none
            return pastRecordCell
        }
        
        
        guard let pastRecordCell = tableView.dequeueReusableCell(RecordCell.self, for: indexPath) else { return .init()}
        pastRecordCell.mainView.setViewModel(vm.tableVM.cells[indexPath.section][indexPath.row - 1])
        pastRecordCell.selectionStyle = .none
        return pastRecordCell
    }
    
}

//MARK: - UITableViewDelegate

extension ChartsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recordVM = vm.tableVM.cells[safe: indexPath.section]?[safe: indexPath.row - 1] else { return }
        coordinator.navigateTo(ChartsNavigationRoute.editRecord(vm.car, recordVM.record))
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layout.isAutoDragging = false
        
        let currentContentOffsetY = scrollView.contentOffset.y
        
        let scrollDiff = currentContentOffsetY - layout.previousContentOffsetY
        // Верхняя граница начала bounce эффекта
        let bounceBorderContentOffsetY = -scrollView.contentInset.top
        
        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY
        
        if let currentScrollConstraintConstant = layout.animatedTableViewConstraint?.layoutConstraints.first?.constant,
           let maxConstraintConstant = layout.maxConstraintConstant {
            
            let minConstraintConstant = layout.tableViewMinConstraintConstant
            var newConstraintConstant = currentScrollConstraintConstant
            
            //Процент завершения анимации
            //Оставить реализацию
            //            let animationCompletionPercent = (maxConstraintConstant - currentScrollConstraintConstant) / (maxConstraintConstant - minConstraintConstant)
            
            if contentMovesUp {
                newConstraintConstant = max(currentScrollConstraintConstant - scrollDiff, minConstraintConstant)
                layout.contentMovesUp = true
                layout.contentMovesDown = false
                
            } else if contentMovesDown {
                newConstraintConstant = min(currentScrollConstraintConstant - scrollDiff, maxConstraintConstant)
                layout.contentMovesUp = false
                layout.contentMovesDown = true
            }
            
            if newConstraintConstant != currentScrollConstraintConstant,
               !layout.table.table.isHidden, !layout.upAnimator.isRunning, !layout.downAnimator.isRunning {
                layout.newConstraintConstant = newConstraintConstant
                scrollView.contentOffset.y = layout.previousContentOffsetY
            }
            
            layout.previousContentOffsetY = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        layout.isAutoDragging = true
        
        if !decelerate {
            switch layout.newConstraintConstant {
                case 0...layout.maxConstraintConstant! / 2:
                    layout.newConstraintConstant = layout.tableViewMinConstraintConstant
                    layout.upAnimator.startAnimation()
                case layout.maxConstraintConstant! / 2...layout.maxConstraintConstant!:
                    layout.newConstraintConstant = layout.maxConstraintConstant!
                    layout.downAnimator.startAnimation()
                default: break
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        layout.isAutoDragging = true
        
        if layout.contentMovesUp {
            layout.newConstraintConstant = layout.tableViewMinConstraintConstant
            layout.upAnimator.startAnimation()
        } else if layout.contentMovesDown {
            layout.newConstraintConstant = layout.maxConstraintConstant!
            layout.downAnimator.startAnimation()
        }
    }
}
