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
    var navigationBarOriginalOffset : CGFloat?
    var segmentOriginalOffset: CGFloat?
    // - Manager
    var coordinator: Coordinator!
    private var layout: Layout!
    private lazy var tableView = UITableView() {
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
        makeCloseButton(isLeft: true)
        scroll.delegate = self
        layout.titleLabelView.defaultTitle = "Общая информация".localized
        self.navigationItem.titleView = layout.titleLabelView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readCar()
        navigationBarOriginalOffset = navigationController?.navigationBar.frame.origin.y
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layout.isFirstLayoutSubviews {
            layout.maxConstraintConstant = layout.carTopInfo.frame.height + 40
            segmentOriginalOffset = layout.segment.frame.origin.y
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
        
        let isPrem: Bool = SettingsManager.sh.read(.isPremium) ?? false
        vm.addButtonVM.actions = [
            .init(tappableLabelVM:
                    .init(.text("Запланировать".localized),
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
                    .init(.text("Добавить запись".localized),
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
        if scrollView.contentSize.height < contentView.frame.height {
            scrollView.contentSize.height = layout.page.view.frame.height-33
        }
        
        navigationBarOriginalOffset = max(0,max(navigationBarOriginalOffset!-layout.segment.frame.height, scroll.contentOffset.y))
        layout.segment.frame.origin.y = navigationBarOriginalOffset!
        
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
            } else if contentMovesDown {
                newConstraintConstant = min(currentScrollConstraintConstant - scrollDiff, maxConstraintConstant)
                
            }
            //Процент завершения анимации
            //            let animationCompletionPercent = ((layout.maxConstraintConstant ?? 0) - currentScrollConstraintConstant) / ((layout.maxConstraintConstant ?? 0) - layout.scrollMinConstraintConstant)
            if newConstraintConstant != currentScrollConstraintConstant, !tableView.isHidden {
                self.layout.animatedScrollConstraint?.update(offset: newConstraintConstant)
                scrollView.contentOffset.y = layout.previousContentOffsetY
            }
        }
        
        layout.previousContentOffsetY = scrollView.contentOffset.y
    }
}

class NavigationBarAnimatedTitle: UIView {
    private var label = UILabel()
    var changedTitle: String = "" {
        didSet {
            label.text = changedTitle
        }
    }
    
    var defaultTitle: String = "" {
        didSet {
            label.text = defaultTitle
            label.textColor = AppColors.navbarTitle
            label.textAlignment = .center
            label.font = UIFont.custom(size: 16, weight: .bold)
            setNeedsLayout()
        }
    }
    
    var didChangeTitle = false
    let animateUp: CATransition = {
        let animation = CATransition()
        animation.duration = 0.3
        animation.type = .push
        animation.subtype = .fromTop
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }()
    
    let animateDown: CATransition = {
        let animation = CATransition()
        animation.duration = 0.4
        animation.type = .push
        animation.subtype = .fromBottom
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = self.frame
        addSubview(label)
        clipsToBounds = true
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
