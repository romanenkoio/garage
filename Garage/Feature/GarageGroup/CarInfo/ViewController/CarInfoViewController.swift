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
    let upTimer = Timer.publish(every: 0.0005, on: .main, in: .common).autoconnect()
    let downTimer = Timer.publish(every: 0.0005, on: .main, in: .common).autoconnect()
    
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
        layout.page.delegate = self
        layout.titleLabelView.defaultTitle = "Общая информация"
        self.navigationItem.titleView = layout.titleLabelView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readCar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

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
        let bounceBorderContentOffsetY = -scrollView.contentInset.top
        
        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY
        
        if let currentScrollConstraintConstant = layout.animatedScrollConstraint?.layoutConstraints.first?.constant,
           let maxConstraintConstant = layout.maxConstraintConstant {
            
            let minConstraintConstant = layout.scrollMinConstraintConstant
            var newConstraintConstant = currentScrollConstraintConstant
            
            newConstraintConstant = currentScrollConstraintConstant
            //Процент завершения анимации
            //Оставить реализацию
//            let animationCompletionPercent = (maxConstraintConstant - currentScrollConstraintConstant) / (maxConstraintConstant - minConstraintConstant)
            
            if contentMovesUp {
                newConstraintConstant = max(currentScrollConstraintConstant - scrollDiff, minConstraintConstant)
                
                upTimer.sink {[weak self] _ in
                    guard let self else { return }
                    if newConstraintConstant <= maxConstraintConstant / 1.1,
                       newConstraintConstant > 0 {
                        layout.newConstraintConstant -= 0.1
                    }
                }
                .store(in: &cancellables)
                
            } else if contentMovesDown {
                newConstraintConstant = min(currentScrollConstraintConstant - scrollDiff, maxConstraintConstant)
                
                downTimer.sink {[weak self] _ in
                    guard let self else { return }
                    if newConstraintConstant <= maxConstraintConstant / 1.1,
                       newConstraintConstant < maxConstraintConstant {
                        layout.newConstraintConstant += 0.1
                    }
                }
                .store(in: &cancellables)
            }
            
            if newConstraintConstant != currentScrollConstraintConstant,
               !tableView.isHidden {
                layout.newConstraintConstant = newConstraintConstant
                scrollView.contentOffset.y = layout.previousContentOffsetY
            }
            
            layout.previousContentOffsetY = scrollView.contentOffset.y
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
            label.textColor = UIColor.init(hexString: "#3D3D3D")
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
