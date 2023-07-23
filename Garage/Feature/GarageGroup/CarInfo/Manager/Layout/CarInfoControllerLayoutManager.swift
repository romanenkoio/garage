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
    
    private unowned let vc: CarInfoViewController
    
    private(set) var isFirstLayoutSubviews = true
    var scrollMinConstraintConstant: CGFloat = 0
    var contentOffset:CGFloat = 0
    
    var maxConstraintConstant: CGFloat? {
        didSet {
            setupScrollView()
            remakeConstraintsAfterLayout()
            vc.view.layoutIfNeeded()
            isFirstLayoutSubviews = false
        }
    }
    
    var animationCompletionPercentage: Double = 0 {
        didSet {
            animator.fractionComplete = animationCompletionPercentage
            print(animationCompletionPercentage)
            animator.addAnimations { [weak self] in
                guard let self else { return }
                self.carTopInfo.transform = CGAffineTransform(translationX: -self.carTopInfo.bounds.width, y: 0)
            }
        }
    }
    
    var animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn)
    
    var animatedCarTopInfoConstraint: Constraint?
    var animatedScrollConstraint: Constraint?
    var previousContentOffsetY: CGFloat = 0
    var newConstraintConstant: CGFloat = 0
    let titleLabelView = NavigationBarAnimatedTitle.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    
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
        vc.makeRightNavBarButton(buttons: [editButton])
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
        
        carTopInfo.snp.makeConstraints { make in
            make.leading.trailing.equalTo(vc.view.safeAreaLayoutGuide)
            animatedCarTopInfoConstraint = make.bottom.equalTo(vc.view.safeAreaLayoutGuide.snp.top).offset(maxConstraintConstant!).constraint
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
    }
}
