//
//  PastRecordsViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.06.23.
//  
//

import UIKit

class PastRecordsViewController: BasicViewController {

    // - UI
    typealias Coordinator = PastRecordsControllerCoordinator
    typealias Layout = PastRecordsControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: Coordinator!
    private var layout: Layout!
    var action: ((CGFloat) -> ())?
    
    init(vm: ViewModel, action: ((CGFloat) -> ())? = nil) {
        self.vm = vm
        self.action = action
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        disableScrollView()
        //layout.table.reload()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        view.frame.size.height = layout.table.table.contentSize.height
        print("past rec vc", view.bounds.size.height)
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.table.setViewModel(vm.tableVM)
        layout.addButton.setViewModel(vm.addButtonVM)
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cells  in
                self?.layout.table.reload()
                self?.layout.addButton.isHidden = cells.isEmpty
            }
            .store(in: &cancellables)
        
        let action: Action = .touchUpInside {
            self.coordinator.navigateTo(PastRecordsNavigationRoute.createPastRecord(self.vm.car))
        }
        
        vm.tableVM.addButtonVM.action = action
        vm.addButtonVM.buttonVM.action = action
    }
    
}

// MARK: -
// MARK: - Configure

extension PastRecordsViewController {

    private func configureCoordinator() {
        coordinator = PastRecordsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = PastRecordsControllerLayoutManager(vc: self)
    }
    
}

// MARK: - UITableViewDataSource

extension PastRecordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pastRecordCell = tableView.dequeueReusableCell(RecordCell.self, for: indexPath) else { return .init()}
        let vm = RecordView.ViewModel(record: Record(carID: "\(indexPath.row)", mileage: 300000, date: .now))
        pastRecordCell.mainView.setViewModel(vm)
        
        view.frame.size.height = pastRecordCell.frame.height * 20
        view.setNeedsLayout()
        print("table vc", view.bounds.size.height)
        print(pastRecordCell.bounds.height)
        return pastRecordCell
    }
    
    
}

// MARK: - UITableViewDelegate

extension PastRecordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        
    }

}
