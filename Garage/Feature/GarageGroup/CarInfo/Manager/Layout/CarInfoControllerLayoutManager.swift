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
    private var isFirstLayoutSubviews = true
    var scrollMinConstraintConstant: CGFloat = 0
    var maxConstraintConstant: CGFloat? {
        didSet {
            if isFirstLayoutSubviews {
                setupScrollView()
                remakeConstraintsAfterLayout()
                vc.view.layoutIfNeeded()
                isFirstLayoutSubviews = false
            }
        }
    }
    var animatedScrollConstraint: Constraint?
    var topStackTopConstraint: Constraint?
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
        
        self.vc.contentView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(self.vc.view)
            make.height.equalTo(self.page.view.frame.height + 70)
            make.bottom.top.equalToSuperview()
        }
    }
    
    private func setupScrollView() {
        vc.scroll.snp.removeConstraints()
        vc.view.bringSubviewToFront(vc.scroll)
        vc.view.bringSubviewToFront(addButton)
        
        vc.scroll.snp.makeConstraints { make in
            animatedScrollConstraint = make.top.equalTo(vc.view.safeAreaLayoutGuide).offset(maxConstraintConstant ?? 0).constraint
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
        
        topStack.snp.makeConstraints { make in
            topStackTopConstraint = make.top.equalTo(vc.view.safeAreaLayoutGuide).constraint
            make.leading.trailing.equalTo(vc.view.safeAreaLayoutGuide)
        }
        
        segment.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets.horizintal)
        }
    }
}
