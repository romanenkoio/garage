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
    var animatedScrollConstraint: Constraint?
    var previousContentOffsetY: CGFloat = 0
    
    // - Flag
    private(set) var isFirstLayoutSubviews = true
    
    // - Animation properties
    let upAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
    let downAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
    var initialContentSizeHeight: CGFloat = 0
    var contentMovesUp: Bool = false
    var contentMovesDown: Bool = false
    var scrollMinConstraintConstant: CGFloat = 0
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
            
            let carTopAnimationScale = max(1.0,min(2.0 - newConstraintConstant / maxConstraintConstant!, 2))
            let carTopAlphaScale = min(max(1.0 - newConstraintConstant / (maxConstraintConstant! - 20.0), 0.0), 1.0)
            let contentViewCornerScale = max(newConstraintConstant / 9, 0)
            

            upAnimator.addAnimations {[weak self] in
                guard let self else { return }
                self.makeAnimations(with: newConstraintConstant)
            }
      
            downAnimator.addAnimations {[weak self] in
                guard let self else { return }
                self.makeAnimations(with: newConstraintConstant)
            }
            
          
                switch newConstraintConstant {
                    case 0:
                        if vc.tableView.contentSize.height == vc.view.frame.height + 100 {
                            vc.tableView.contentSize.height = initialContentSizeHeight
                        }
                        
                        if let label = vc.navigationItem.titleView as? NavigationBarTitleAnimator {
                            if !titleLabelView.didChangeTitle {
                                label.layer.add(titleLabelView.animateUp, forKey: "changeTitle")
                                label.changedTitle = "\(vc.vm.car.brand) \(vc.vm.car.model)"
                                titleLabelView.didChangeTitle = true
                                print(initialContentSizeHeight)
                            }
                        }
                        
                        upAnimator.stopAnimation(true)
                    case maxConstraintConstant!:
                        downAnimator.stopAnimation(true)
                    default:
                        if vc.tableView.contentSize.height < vc.view.frame.height {
                            vc.tableView.contentSize.height = vc.view.frame.height + 100
                        }
                        makeAnimations(with: newConstraintConstant)
                        
                }
                
//            } else if contentMovesDown {
//                switch newConstraintConstant {
//                  
//                    default:
//                        if vc.tableView.contentSize.height < vc.view.frame.height {
//                            vc.tableView.contentSize.height = vc.view.frame.height + 100
//                        }
//                        
//                        if let label = vc.navigationItem.titleView as? NavigationBarTitleAnimator {
//                            if  titleLabelView.didChangeTitle {
//                                label.layer.add(titleLabelView.animateUp, forKey: "changeTitle")
//                                label.defaultTitle = titleLabelView.defaultTitle
//                                titleLabelView.didChangeTitle = false
//                            }
//                        }
//                        makeAnimations(with: newConstraintConstant)
//                }
//            }
        }
    }
    
    // - UIComponents
    let titleLabelView = NavigationBarTitleAnimator.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    
    lazy var carTopInfo = CarTopInfoView()
    lazy var addButton = FloatingButtonView()
    
    lazy var recordsView: BasicView = {
       let view = BasicView()
        view.cornerRadius = 20
        view.backgroundColor = AppColors.background
        return view
    }()
    
    lazy var segment = BasicSegmentView<RecordType>()
    lazy var page = BasicPageController(vm: vc.vm.pageVM)
    
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
        let editButton = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                guard let self else { return }
                self.vc.coordinator.navigateTo(CarInfoNavigationRoute.edit(self.vc.vm.car))
            },
            image: UIImage(named: "edit_ic"))
        
        let chartButton = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                guard let self else { return }
                self.vc.coordinator.navigateTo(CarInfoNavigationRoute.statistic(self.vc.vm.car))
            },
            image: UIImage(named: "stat_ic"))
        
        vc.makeRightNavBarButton(buttons: [editButton, chartButton])
    }
    
    func remakeConstraintsAfterLayout() {
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
    
    private func makeAnimations(with constant: CGFloat) {
        let carTopAnimationScale = max(1.0,min(2.0 - constant / maxConstraintConstant!, 2))
        let carTopAlphaScale = min(max(1.0 - constant / (maxConstraintConstant! - 20.0), 0.0), 1.0)
        let contentViewCornerScale = max(constant / 9, 0)
        
        self.vc.view.layoutIfNeeded()
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
