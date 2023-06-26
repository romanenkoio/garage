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
    var segmentMinConstraintConstant: CGFloat = 0
    private var firstLayout = true
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
    var animatedSegmentTopConstaint: Constraint?
    var previousContentOffsetY: CGFloat = 0
    
    lazy var topStack: BasicStackView = {
        let view = BasicStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.cornerRadius = 12
        view.spacing = 10
        view.paddingInsets = .init(left: 20)
        view.backgroundColor = .white
        view.clipsToBounds = false
        return view
    }()
    
    lazy var logoImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.cornerRadius = 39
        return view
    }()
    
    lazy var recordsView: BasicView = {
       let view = BasicView()
        view.cornerRadius = 20
        view.backgroundColor = AppColors.background
        return view
    }()
    
    lazy var brandModelLabel = BasicLabel()
    lazy var yearLabel = BasicLabel()
    lazy var vinLabel = BasicLabel()
    lazy var mileageLabel = BasicLabel()
    lazy var segment = BasicSegmentView<RecordType>()
    lazy var addRecordButton = AlignedButton()
    
    lazy var page = BasicPageController(vm: vc.vm.pageVM)
    
    lazy var table: BasicTableView = {
        let view = BasicTableView()
        view.setupTable(dataSource: vc, delegate: vc)
        view.register(BasicTableCell<RecordView>.self)
        view.backgroundColor = .clear

        return view
    }()
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
            
            self.page.view.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.greaterThanOrEqualTo(self.vc.view.safeAreaLayoutGuide.layoutFrame.height - 20)
                make.top.equalTo(self.segment.snp.bottom).offset(10)
            }
            
            self.vc.contentView.snp.remakeConstraints { make in
                make.leading.trailing.equalTo(self.vc.view)
                make.height.equalTo(self.page.view.frame.height + 70)
                make.bottom.top.equalToSuperview()
            }
            
        }
    }
    
    private func setupScrollView() {
        vc.scroll.snp.removeConstraints()
        vc.view.bringSubviewToFront(vc.scroll)
        
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
    }
    
    private func makeLayout() {
        vc.view.addSubview(topStack)
        topStack.addArrangedSubviews([
            logoImage,
            brandModelLabel,
            mileageLabel,
            yearLabel,
            vinLabel
        ])
        vc.contentView.addSubview(segment)
        vc.contentView.addSubview(page.view)
        vc.addChild(page)
        page.didMove(toParent: vc)

        //vc.contentView.addSubview(addRecordButton)
        
        vc.contentView.backgroundColor = .clear
    
        brandModelLabel.font = .custom(size: 18, weight: .black)
        yearLabel.font = .custom(size: 14, weight: .bold)
        vinLabel.font = .custom(size: 14, weight: .bold)
        mileageLabel.font = .custom(size: 14, weight: .bold)
    }
    
    private func makeConstraint() {
        logoImage.snp.makeConstraints { make in
            make.height.width.equalTo(78)
        }
        
        
        topStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(vc.view.safeAreaLayoutGuide)
        }
        
        segment.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets.horizintal)
            //make.bottom.equalTo(vc.scroll.snp.top)
        }
        
//        addRecordButton.snp.makeConstraints { make in
//            make.top.equalTo(recordsView.snp.bottom).offset(20)
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-20)
//        }
    }
}
