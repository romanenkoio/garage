//
//  CarInfoViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//  
//

import UIKit
import SnapKit

class CarInfoViewController: BasicViewController {

    // - UI
    typealias Coordinator = CarInfoControllerCoordinator
    typealias Layout = CarInfoControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    var coordinator: Coordinator!
    private var layout: Layout!
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init()
    }
    
    deinit {
        print("deinit CarInfoViewController")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar(false)
        hideTabBar(true)
        makeCloseButton(isLeft: true)
        scroll.delegate = self
        title = "Общая информация"
        self.vm.pageVM.controllers.first?.tableView.delegate = self
        vm.segmentVM.setSelected(.paste)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readCar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.maxConstraintConstant = layout.carTopInfo.frame.size.height + 40
    }
    
    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    
    override func binding() {
        layout.segment.setViewModel(vm.segmentVM)
        layout.addButton.setViewModel(vm.addButtonVM)
        layout.carTopInfo.setViewModel(vm.carTopInfoVM)
        
        let isPrem: Bool = SettingsManager.sh.read(.isPremium) ?? false
        vm.addButtonVM.actions = [
            .init(tappableLabelVM:
                        .init(.text("Запланировать"),
                            action: { [weak self] in
                                guard let self else { return }
                                let isReminderExist = vm.remindersVM.tableVM.cells.count > 1
                                if isPrem {
                                    coordinator.navigateTo(CarInfoNavigationRoute.createReminder(vm.car))
                                } else if !isPrem, isReminderExist {
                                    coordinator.navigateTo(CarInfoNavigationRoute.createReminder(vm.car))
//                                    MARK: open premium
                                } else if !isPrem, !isReminderExist {
                                    coordinator.navigateTo(CarInfoNavigationRoute.createReminder(vm.car))

                                }
                                self.vm.addButtonVM.dismissButtons()
                            }),
                  image: isPrem ? UIImage(named: "checkmark_fb_ic") : UIImage(systemName: "lock.fill")),
            .init(tappableLabelVM:
                    .init(.text("Добавить запись"),
                    action: { [weak self] in
                        guard let self else { return }
                        coordinator.navigateTo(CarInfoNavigationRoute.createRecord(vm.car))
                        self.vm.addButtonVM.dismissButtons()
                    }),
                image: UIImage(named: "pencil_fb_ic"))
        ]
        
        vm.segmentVM.$selectedIndex
            .sink {[weak self] index in
                guard let self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
                    self.vm.pageVM.controllers[index].tableView.delegate = self
                    self.vm.pageVM.setIndexCandidate()
                    let visibleIndexPaths = self.vm.pageVM.controllers[index].tableView.indexPathsForVisibleRows
                    let completelyVisible = visibleIndexPaths?.count != 0
                    self.scroll.isScrollEnabled = completelyVisible
                }
            }
            .store(in: &cancellables)
        
        vm.remindersVM.completeReminder = { [weak self] reminder in
            guard let self else { return }
            coordinator.navigateTo(CarInfoNavigationRoute.createRecordFromReminder(vm.car, reminder))
        }
        
        vm.carTopInfoVM.vinLabelVM.action = { [weak self] in
            guard let self else { return }
            
            let string = "\(vm.car.brand) \(vm.car.model) \(vm.car.year.wrappedString)\n\(vm.car.win.wrapped)"
            let content: [Any] = [string]
            coordinator.navigateTo(CommonNavigationRoute.share(content))
        }
    }
}

// MARK: -
// MARK: - Configure

extension CarInfoViewController {

    private func configureCoordinator() {
        coordinator = CarInfoControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CarInfoControllerLayoutManager(vc: self)
    }
}

extension CarInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch vm.segmentVM.selectedItem {
            
        case .paste:
                guard let recordVM = vm.pastRecordsVM.tableVM.cells[safe: indexPath.section]?[safe: indexPath.row - 1] else { return }
                coordinator.navigateTo(CarInfoNavigationRoute.editRecord(vm.car, recordVM.record))
         
        case .future:
            guard let reminder = vm.remindersVM.tableVM.cells[safe: indexPath.row] else { return }
            coordinator.navigateTo(CarInfoNavigationRoute.editReminder(vm.car, reminder))
        }
    }
}

extension CarInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffsetY = scrollView.contentOffset.y
        let scrollDiff = currentContentOffsetY - layout.previousContentOffsetY
        
        // Верхняя граница начала bounce эффекта
        let bounceBorderContentOffsetY = -scrollView.contentOffset.y
        
        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY
        
        if let currentScrollConstraintConstant = layout.animatedScrollConstraint?.layoutConstraints.first?.constant,
           let maxConstraintConstant = layout.maxConstraintConstant {
            var newConstraintConstant = currentScrollConstraintConstant
            
            if contentMovesUp {
                // Уменьшаем константу констрэйнта
                newConstraintConstant = max(currentScrollConstraintConstant - scrollDiff, layout.scrollMinConstraintConstant)
                
                if newConstraintConstant < maxConstraintConstant,
                   !self.vm.pageVM.controllers[self.vm.pageVM.index].tableView.visibleCells.isEmpty {
                    
                    self.layout.animatedScrollConstraint?.update(offset: layout.scrollMinConstraintConstant)
                    self.scroll.contentOffset.y = self.layout.previousContentOffsetY
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        if scrollView == self.scroll {
                            self.scroll.isScrollEnabled = false
                            self.vm.pageVM.controllers[self.vm.pageVM.index].tableView.isScrollEnabled = true
                        }
                    }
                }
                
            } else if contentMovesDown {
                newConstraintConstant = min(currentScrollConstraintConstant - scrollDiff, maxConstraintConstant)
                
                if newConstraintConstant >= maxConstraintConstant / 2 {
                    self.layout.animatedScrollConstraint?.update(offset: maxConstraintConstant)
                    self.scroll.contentOffset.y = self.layout.previousContentOffsetY
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                        self.scroll.isScrollEnabled = true
                        self.vm.pageVM.controllers[self.vm.pageVM.index].tableView.isScrollEnabled = false
                    }
                }
            }
            
            //Процент завершения анимации
            //            let animationCompletionPercent = ((layout.maxConstraintConstant ?? 0) - currentScrollConstraintConstant) / ((layout.maxConstraintConstant ?? 0) - layout.scrollMinConstraintConstant)
            //            layout.previousContentOffsetY = scrollView.contentOffset.y
        }
    }
}

