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
    
    lazy var tableView = UITableView() {
        didSet {
            tableView.delegate = self
            scroll.isScrollEnabled = false
            tableView.isScrollEnabled = true
        }
    }
    
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
        makeCloseButton(side: .left)
        scroll.delegate = self
        scroll.showsVerticalScrollIndicator = false
        layout.page.delegate = self
        layout.titleLabelView.defaultTitle = "Общая информация"
        self.navigationItem.titleView = layout.titleLabelView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readCar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layout.isFirstLayoutSubviews {
            layout.maxConstraintConstant = layout.carTopInfo.frame.height
        }
    }
    
    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }
    
    override func binding() {
        layout.segment.setViewModel(vm.segmentVM)
        layout.addButton.setViewModel(vm.addButtonVM)
        layout.carTopInfo.setViewModel(vm.carTopInfoVM)
        
        let isPrem = Environment.isPrem
        vm.addButtonVM.actions = [
            .init(tappableLabelVM:
                    .init(.text("Запланировать"),
                          action: { [weak self] in
                              guard let self else { return }
                              let isReminderExist = vm.remindersVM.tableVM.cells.count > 1
                              if isPrem {
                                  coordinator.navigateTo(CarInfoNavigationRoute.createReminder(vm.car))
                              } else if !isPrem, isReminderExist {
                                  coordinator.navigateTo(CommonNavigationRoute.premium)
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
        
        vm.$pageVCTableView.sink {[weak self] tableView in
            guard let self,
                  let tableView else { return }
            self.tableView = tableView
            self.layout.initialContentSizeHeight = tableView.contentSize.height
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
            guard let reminder = vm.remindersVM.tableVM.cells[safe: indexPath.section] else { return }
            coordinator.navigateTo(CarInfoNavigationRoute.editReminder(vm.car, reminder))
        }
    }
}

extension CarInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layout.isAutoDragging = false
        
        let currentContentOffsetY = scrollView.contentOffset.y
        
        let scrollDiff = currentContentOffsetY - layout.previousContentOffsetY
        // Верхняя граница начала bounce эффекта
        let bounceBorderContentOffsetY = -scrollView.contentInset.top
        
        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY
        
        if let currentScrollConstraintConstant = layout.animatedScrollConstraint?.layoutConstraints.first?.constant,
           let maxConstraintConstant = layout.maxConstraintConstant {
            
            let minConstraintConstant = layout.scrollMinConstraintConstant
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
               !tableView.isHidden, !layout.upAnimator.isRunning, !layout.downAnimator.isRunning {
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
                    layout.newConstraintConstant = layout.scrollMinConstraintConstant
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
            layout.newConstraintConstant = layout.scrollMinConstraintConstant
            layout.upAnimator.startAnimation()
        } else if layout.contentMovesDown {
            layout.newConstraintConstant = layout.maxConstraintConstant!
            layout.downAnimator.startAnimation()
        }
    }
}

extension CarInfoViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed {
            layout.page.vm.setIndexCandidate()
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        guard let controller = pendingViewControllers.first,
              let index = layout.page.vm.controllers.firstIndex(of: controller as! BasicViewController)
        else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        layout.page.vm.indexCandidate = index
    }
}
