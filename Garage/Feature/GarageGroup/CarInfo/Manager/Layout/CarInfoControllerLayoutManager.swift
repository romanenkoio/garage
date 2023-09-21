//
//  CarInfoControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//  
//

import UIKit
import SnapKit

final class CarInfoControllerLayoutManager {
    
    // - Property
    private unowned let vc: CarInfoViewController
    private(set) var animatedScrollConstraint: Constraint?
    var previousContentOffsetY: CGFloat = 0
    
    // - Flag
    private(set) var isFirstLayoutSubviews = true
    
    // - Animation properties
    private(set) var upAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
    private(set) var downAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
    var initialContentSizeHeight: CGFloat = 0
    var isAutoDragging: Bool = false
    var contentMovesUp = false
    var contentMovesDown = false
    private(set) var scrollMinConstraintConstant: CGFloat = 0
    var maxConstraintConstant: CGFloat? {
        didSet {
            setupScrollView()
            remakeConstraintsAfterLayout()
            vc.view.layoutIfNeeded()
            isFirstLayoutSubviews = false
        }
    }
    
    var newConstraintConstant: CGFloat = 0 {
        didSet {
            animatedScrollConstraint?.update(offset: newConstraintConstant)
            
            if isAutoDragging {
                upAnimator.addAnimations {[weak self] in
                    guard let self else { return }
                    self.makeAutoAnimations(with: newConstraintConstant)
                }
                
                downAnimator.addAnimations {[weak self] in
                    guard let self else { return }
                    self.makeAutoAnimations(with: newConstraintConstant)
                    
                }
            } else {
                makeManualAnimations(with: newConstraintConstant)
            }
            
            switch newConstraintConstant {
                case 0:
                    if let label = vc.navigationItem.titleView as? NavigationBarTitleAnimator {
                        if !titleLabelView.didChangeTitle {
                            label.layer.add(titleLabelView.animateUp, forKey: "changeTitle")
                            label.changedTitle = "\(vc.vm.car.brand) \(vc.vm.car.model)"
                            titleLabelView.didChangeTitle = true
                            print(initialContentSizeHeight)
                        }
                    }
                    
                    if vc.tableView.contentSize.height == vc.view.frame.height + 150 {
                        vc.tableView.contentSize.height = initialContentSizeHeight
                    }
                    
                    upAnimator.stopAnimation(true)
                    
                case maxConstraintConstant!:
                    downAnimator.stopAnimation(true)
                    
                default:
                    if vc.tableView.contentSize.height < vc.view.frame.height + 150 {
                        vc.tableView.contentSize.height = vc.view.frame.height + 150
                    }
                    if let label = vc.navigationItem.titleView as? NavigationBarTitleAnimator {
                        if  titleLabelView.didChangeTitle {
                            label.layer.add(titleLabelView.animateUp, forKey: "changeTitle")
                            label.defaultTitle = titleLabelView.defaultTitle
                            titleLabelView.didChangeTitle = false
                        }
                    }
            }
        }
    }
    
    // - UIComponents
    let titleLabelView = NavigationBarTitleAnimator.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    
    private(set) lazy var carTopInfo = CarTopInfoView()
    private(set) lazy var addButton = FloatingButtonView()
    
    private(set) lazy var recordsView: BasicView = {
       let view = BasicView()
        view.cornerRadius = 20
        view.backgroundColor = AppColors.background
        return view
    }()
    
    private(set) lazy var segment = BasicSegmentView<RecordType>()
    private(set) lazy var page = BasicPageController(vm: vc.vm.pageVM)
    
    // - Init
    init(vc: CarInfoViewController) {
        self.vc = vc
        configure()
        makeNavbar()
    }
    
    deinit {
        print("deinit")
    }
    
    private func makeNavbar() {
        var buttons: [NavBarButton.ViewModel] = .empty

        let editButton = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                guard let self else { return }
                self.vc.coordinator.navigateTo(CarInfoNavigationRoute.edit(self.vc.vm.car))
            },
            image: UIImage(named: "edit_ic"))
        buttons.append(editButton)
        
        if !RealmManager<Record>().read().filter({ $0.carID == vc.vm.car.id }).isEmpty {
            let chartButton = NavBarButton.ViewModel(
                action: .touchUpInside { [weak self] in
                    guard let self else { return }
                    if Environment.isPrem {
                        self.vc.coordinator.navigateTo(CarInfoNavigationRoute.statistic(self.vc.vm.car))
                    } else {
                        self.vc.coordinator.navigateTo(CommonNavigationRoute.premium)
                    }
                },
                image: UIImage(named: "stat_ic"))
            buttons.append(chartButton)
        }
       
        vc.makeRightNavBarButton(buttons: buttons)
    }
    
    private func remakeConstraintsAfterLayout() {
        self.page.view.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(self.vc.view.safeAreaLayoutGuide.layoutFrame.height - 20)
            make.top.equalTo(self.segment.snp.bottom)
        }
        if let screenHeight = vc.view.window?.screen.bounds.height {
            self.vc.contentView.snp.remakeConstraints { make in
                make.leading.trailing.equalTo(vc.view)
                make.top.equalTo(vc.scroll.contentLayoutGuide.snp.top)
                make.bottom.equalTo(vc.scroll.contentLayoutGuide.snp.bottom)
                make.height.equalTo(screenHeight + 70)
            }
        }
    }
    
    private func setupScrollView() {
        vc.scroll.snp.removeConstraints()
        vc.view.bringSubviewToFront(vc.scroll)
        vc.view.bringSubviewToFront(addButton)
        vc.contentView.bringSubviewToFront(segment)
        
        vc.scroll.snp.makeConstraints { make in
            animatedScrollConstraint = make.top.equalTo(vc.view.safeAreaLayoutGuide).offset(maxConstraintConstant!).constraint
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func makeAutoAnimations(with constant: CGFloat) {
        let carTopAnimationScale = max(1.0,min(2.0 - constant / maxConstraintConstant!, 2))
        let carTopAlphaScale = min(max(1.0 - constant / (maxConstraintConstant! - 20.0), 0.0), 1.0)
        let contentViewCornerScale = max(constant / 9, 0)
        
        self.vc.view.layoutIfNeeded()
        self.carTopInfo.transform = CGAffineTransform(scaleX: carTopAnimationScale, y: carTopAnimationScale)
        self.carTopInfo.alpha = 1 - carTopAlphaScale
        self.vc.contentView.cornerRadius = contentViewCornerScale
    }
    
    private func makeManualAnimations(with constant: CGFloat) {
        let carTopAnimationScale = max(1.0,min(2.0 - constant / maxConstraintConstant!, 2))
        let carTopAlphaScale = min(max(1.0 - constant / (maxConstraintConstant! - 20.0), 0.0), 1.0)
        let contentViewCornerScale = max(constant / 9, 0)
        
        self.carTopInfo.transform = CGAffineTransform(scaleX: carTopAnimationScale, y: carTopAnimationScale)
        self.carTopInfo.alpha = 1 - carTopAlphaScale
        self.vc.contentView.cornerRadius = contentViewCornerScale
    }
}

// MARK: -
// MARK: - Configure

fileprivate extension CarInfoControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
        vc.contentView.backgroundColor = AppColors.background
        
    }
    
    private func makeLayout() {
        vc.view.addSubview(carTopInfo)
        vc.contentView.addSubview(segment)
        vc.contentView.addSubview(page.view)
        vc.addChild(page)
        page.didMove(toParent: vc)
        vc.view.addSubview(addButton)

        vc.view.bringSubviewToFront(addButton)
    }
    
    private func makeConstraint() {
        addButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(vc.view.safeAreaLayoutGuide).inset(UIEdgeInsets(bottom: 24, right: 16))
        }
        
        segment.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets.horizintal)
        }
        
        carTopInfo.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(vc.view.safeAreaLayoutGuide)
        }
    }
}
