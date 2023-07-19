//
//  BackupViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 16.07.23.
//  
//

import UIKit

class BackupViewController: BasicViewController {

    // - UI
    typealias Coordinator = BackupControllerCoordinator
    typealias Layout = BackupControllerLayoutManager
    
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
        makeCloseButton(isLeft: true)
        title = "Резервная копия"
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
    
}

// MARK: -
// MARK: - Configure

extension BackupViewController {

    private func configureCoordinator() {
        coordinator = BackupControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = BackupControllerLayoutManager(vc: self)
    }
    
    private func hadleSelection(_ type: DataSubSetting) {
        switch type {
        case .transfer:
            transferBackup()
        case .backup:
            break
        case .save:
            saveBackup()
        case .restore:
            restoreBackup()
        case .remove:
            removeBackup()
        }
    }
    
    private func transferBackup() {
        showLoader()
        DispatchQueue.global().async { [weak self] in
            guard let url = Storage.url(for: .backup, from: .documents) else { return }
            let content: [Any] = [url]
            DispatchQueue.main.async { [weak self] in
                self?.dismissLoader()
                self?.coordinator.navigateTo(CommonNavigationRoute.share(content))
            }
        }
    }
    
    func removeBackup() {
        let dialogVM = Dialog.ViewModel(title: .text("Удалить резервную копию?"))
        dialogVM.confirmButton.action = .touchUpInside { [weak self] in
            guard let self else { return }
            showLoader()
            DispatchQueue.global().async { [weak self] in
                Storage.remove(.backup, from: .documents) {
                    DispatchQueue.main.async { [weak self] in
                        self?.vm.reload() { [weak self] _ in
                            DispatchQueue.main.async { [weak self] in
                                self?.dismissLoader()
                                self?.dismiss(animated: true)
                            }}}}}
        }
        self.coordinator.navigateTo(CommonNavigationRoute.confirmPopup(vm: dialogVM))
    }
    
    func restoreBackup() {
       
      
        let action: Action = .touchUpInside { [weak self] in
            guard let self else { return }
            showLoader()
            DispatchQueue.global().async { [weak self] in
                guard let backup = Storage.retrieve(.backup, from: .documents, as: Backup.self) else { return }
                RealmManager().removeAll()
                backup.saveCurrent() { [weak self] in
                    DispatchQueue.main.async {  [weak self] in
                        self?.vm.reload(completion: { [weak self] _ in
                            self?.dismissLoader()
                        })
                    }
                }
            }
        }
        
        let dialogVM = Dialog.ViewModel(
            title: .text("Восстановить данные из резервной копии?"),
            subtitle: .text("Все текущие данные будут удалены"),
            confirmTitle: "Восстановить",
            confirmColor: AppColors.green,
            confirmAction: action
        )
        
        self.coordinator.navigateTo(CommonNavigationRoute.confirmPopup(vm: dialogVM))
    }
    
    func reload() {
        showLoader()
        vm.reload { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self?.dismissLoader()
            }
        }
    }
    
    private func saveBackup() {
        showLoader()
        DispatchQueue.global().async { [weak self] in
            Storage.store(Backup(), to: .documents, as: .backup) { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.vm.reload() { [weak self] _ in
                        self?.dismissLoader()
                    }
                }
            }
        }
    }
}

extension BackupViewController: UITableViewDataSource {
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
    
        settingCell.mainView.setViewModel(.init(point: point))
        settingCell.selectionStyle = .none
        return settingCell
    }
}

extension BackupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let type = vm.settingsPoint[safe: indexPath.section]?[safe: indexPath.row] else { return }
        self.hadleSelection(type)
    }
}
