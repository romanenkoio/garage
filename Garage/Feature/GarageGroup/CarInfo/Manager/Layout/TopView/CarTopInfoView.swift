//
//  TopView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 27.06.23.
//

import UIKit

class CarTopInfoView: BasicStackView {
    private lazy var modelStack: BasicStackView = {
        let view = BasicStackView()
        view.axis = .horizontal
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var infolabelsStack: BasicStackView = {
        let view = BasicStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.paddingInsets = .init(left: 16)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var infoStsck: BasicStackView = {
        let view = BasicStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        view.paddingInsets = .init(top: 16)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var logoImage: BasicImageView = {
        let view = BasicImageView(mode: .scaleAspectFill)
        view.cornerRadius = 40
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.blue.cgColor
        return view
    }()
    
    lazy var brandModelYearLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .left
        return label
    }()
    
    lazy var vinLabel: TappableLabel = {
        let label = TappableLabel()
        label.textAlignment = .center
        label.backgroundColor = AppColors.background
        label.cornerRadius = 12
        label.textInsets = UIEdgeInsets(top: 12, bottom: 12)
        return label
    }()
    
    lazy var mileageLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .center
        label.backgroundColor = AppColors.background
        label.cornerRadius = 12
        label.textInsets = UIEdgeInsets(top: 12, bottom: 12)
        return label
    }()
        
    override init() {
        super.init()
        edgeInsets = UIEdgeInsets(all: 20)
        axis = .vertical
        makeLayout()
        makeConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addArrangedSubviews([modelStack, infoStsck])
        modelStack.addArrangedSubviews([logoImage, infolabelsStack])
        infolabelsStack.addArrangedSubviews([brandModelYearLabel])
        infoStsck.addArrangedSubviews([mileageLabel, vinLabel])
        
        brandModelYearLabel.font = .custom(size: 18, weight: .black)
        mileageLabel.font = .custom(size: 14, weight: .bold)
        vinLabel.font = .custom(size: 14, weight: .bold)
    }
    
    private func makeConstraints() {
        logoImage.snp.makeConstraints { make in
            make.height.width.equalTo(80)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        brandModelYearLabel.setViewModel(vm.brandModelYearLabelVM)
        mileageLabel.setViewModel(vm.milageLabelVM)
        vinLabel.setViewModel(vm.vinLabelVM)
        logoImage.setViewModel(vm.logoVM)
        
        self.vinLabel.isHidden = vm.car.win.wrapped.isEmpty
    }
}
