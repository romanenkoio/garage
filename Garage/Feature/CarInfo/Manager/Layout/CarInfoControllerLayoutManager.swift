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
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.page.view.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.greaterThanOrEqualTo(self.page.vm.controllers[self.page.vm.index].view.frame.size.height)
                make.top.equalTo(self.segment.snp.bottom)
                print("didChangeConstraints",self.page.vm.index,self.page.vm.controllers[self.page.vm.index].view.frame.size.height)
            }
            UIView.animate(withDuration: 0.2) {
                self.vc.view.layoutIfNeeded()
            }
        }
    }
    
    func layoutOnce(safeAreaHeight: Double ) {
        recordsView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(topStack.frame.size.height - safeAreaHeight)
            make.leading.trailing.equalToSuperview()
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
        vc.contentView.addSubview(recordsView)
        recordsView.addSubview(segment)
        vc.addChild(page)
        recordsView.addSubview(page.view)
        page.didMove(toParent: vc)

        vc.contentView.addSubview(addRecordButton)
        
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
            make.leading.trailing.top.equalToSuperview()
        }
        
        recordsView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        segment.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(UIEdgeInsets.horizintal)
        }
        
        page.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segment.snp.bottom)
        }
        
        addRecordButton.snp.makeConstraints { make in
            make.top.equalTo(recordsView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
