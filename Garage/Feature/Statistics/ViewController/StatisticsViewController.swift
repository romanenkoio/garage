//
//  StatisticsViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 13.07.23.
//  
//

import UIKit

class StatisticsViewController: BasicViewController {

    // - UI
    typealias Coordinator = StatisticsControllerCoordinator
    typealias Layout = StatisticsControllerLayoutManager
    
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
        makeCloseButton(isLeft: true)
        disableScrollView()
        title = "Статистика"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.maxConstraintConstant = layout.chartsView.frame.size.height + 20
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        if let chartsViewVM = vm.chartsViewVM {
            layout.chartsView.setViewModel(chartsViewVM)
        }
        
        layout.table.setViewModel(vm.tableVM)
        
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
            }
            .store(in: &cancellables)
    }
    
}

// MARK: -
// MARK: - Configure

extension StatisticsViewController {

    private func configureCoordinator() {
        coordinator = StatisticsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = StatisticsControllerLayoutManager(vc: self)
    }
}

//MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
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

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recordVM = vm.tableVM.cells[safe: indexPath.section]?[safe: indexPath.row - 1] else { return }
        coordinator.navigateTo(StatisticsNavigationRoute.editRecord(vm.car, recordVM.record))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffsetY = scrollView.contentOffset.y
        let scrollDiff = currentContentOffsetY - layout.previousContentOffsetY

        // Upper border of the bounce effect
        let bounceBorderContentOffsetY = -scrollView.contentInset.top

        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY
        
        let currentConstraintConstant = layout.animatedScrollConstraint!.layoutConstraints.first!.constant
           let maxConstraintConstant = layout.maxConstraintConstant!
            
            let minConstraintConstant = layout.tableViewMinConstraintConstant
            
            var newConstraintConstant = currentConstraintConstant
            
            if contentMovesUp {
                // Reducing the constraint's constant
                newConstraintConstant = max(currentConstraintConstant - scrollDiff, minConstraintConstant)
                layout.downTimer.upstream.connect().cancel()
                layout.upTimer.sink {[weak self] _ in
                    guard let self else { return }
                    if newConstraintConstant <= maxConstraintConstant / 1.2,
                       newConstraintConstant > layout.tableViewMinConstraintConstant {
                        layout.newConstraintConstant -= 0.1
                    }
                }
                .store(in: &cancellables)
            } else if contentMovesDown {
                // Increasing the constraint's constant
                newConstraintConstant = min(currentConstraintConstant - scrollDiff, maxConstraintConstant)
                layout.upTimer.upstream.connect().cancel()
                layout.downTimer.sink {[weak self] _ in
                    guard let self else { return }
                    if newConstraintConstant <= maxConstraintConstant {
                        layout.newConstraintConstant += 0.1
                    }
                }
                .store(in: &cancellables)
            }
            
            // If the constant is modified, changing the height and disable scrolling
            if newConstraintConstant != currentConstraintConstant,
               !layout.table.table.isHidden {
                layout.newConstraintConstant = newConstraintConstant
                scrollView.contentOffset.y = layout.previousContentOffsetY
            }

        layout.previousContentOffsetY = scrollView.contentOffset.y
    }
}
