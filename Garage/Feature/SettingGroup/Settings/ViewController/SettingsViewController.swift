//
//  SettingsViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//  
//

import UIKit

class SettingsViewController: BasicViewController {

    // - UI
    typealias Coordinator = SettingsControllerCoordinator
    typealias Layout = SettingsControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: Coordinator!
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
        hideTabBar(false)
        makeLogoNavbar()
        hideTabBar(false)
        makeCloseButton(isLeft: true)
        title = "Настройки"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.setCells()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        self.layout.table.setViewModel(vm.tableVM)
        
        vm.tableVM.$cells
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            self?.layout.table.reload()
        }
        .store(in: &cancellables)
    }
    
    func hadleSelection(_ type: SettingPoint) {
        switch type {
        case .reminders:
            let current: Bool = (SettingsManager.sh.read(.useReminder) ?? true)
            SettingsManager.sh.write(value: !current, for: .useReminder)
            PushManager.sh.reschedule()
        case .mileageReminder:
            let current: Bool = (SettingsManager.sh.read(.mileageReminder) ?? true)
            PushManager.sh.reschedule()
            SettingsManager.sh.write(value: !current, for: .mileageReminder)
        case .backup:
            showLoader()
            readBackupDate { [weak self] date in
                let points: [[DataSubSetting]]
                
                if let date {
                    points = [
                        [.backup(date), .transfer(true)],
                        [.save, .restore(true), .remove(true)]
                    ]
                } else {
                    points = [
                        [.backup("отсутствует"), .transfer(false)],
                        [.save, .restore(false), .remove(false)]
                    ]
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.dismissLoader()
                    self?.coordinator.navigateTo(SettingsNavigationRoute.backup(points))
                }
            }
        case .contactUs:
            break
        case .version:
            break
        case .language:
            break
        case .subscription:
            break
        case .getPremium:
            break
        }
    }
    
    func readBackupDate(completion: @escaping (String?) -> Void) {
        DispatchQueue.global().async {
            guard let backup = Storage.retrieve(.backup, from: .documents, as: Backup.self) else {
                completion(nil)
                return
            }
            
            let date = backup.date.toString(.ddMMyy)
            completion(date)
        }
    }
}

// MARK: -
// MARK: - Configure

extension SettingsViewController {

    private func configureCoordinator() {
        coordinator = SettingsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = SettingsControllerLayoutManager(vc: self)
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingCell = tableView.dequeueReusableCell(BasicTableCell<SettingView>.self),
              let point = vm.settingsPoint[safe: indexPath.section]?[safe: indexPath.row]
        else { return .init() }
    
        let vm = SettingView.ViewModel(point: point)
        vm.switchCompletion = { [weak self] _ in
            self?.hadleSelection(point)
        }
        settingCell.mainView.setViewModel(vm)
        settingCell.selectionStyle = .none
        return settingCell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let type = vm.settingsPoint[safe: indexPath.section]?[safe: indexPath.row] else { return }
        self.hadleSelection(type)
    }
}
