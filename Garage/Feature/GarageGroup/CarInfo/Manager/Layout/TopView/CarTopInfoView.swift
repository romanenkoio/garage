//
//  TopView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 27.06.23.
//

import UIKit

class CarTopInfoView: BasicView {
    
    private lazy var infoStsck: BasicStackView = {
        let view = BasicStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        view.edgeInsets = .init(top: 16)
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
        makeLayout()
        makeConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(logoImage)
        addSubview(brandModelYearLabel)
        addSubview(mileageLabel)
        addSubview(infoStsck)
        infoStsck.addArrangedSubviews([mileageLabel, vinLabel])
        
        brandModelYearLabel.font = .custom(size: 18, weight: .black)
        mileageLabel.font = .custom(size: 14, weight: .bold)
        vinLabel.font = .custom(size: 14, weight: .bold)
        

    }
    
    private func makeConstraints() {
        logoImage.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.leading.top.equalToSuperview().offset(16)
        }
        
        brandModelYearLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImage.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(UIEdgeInsets(right: 16))
            make.centerY.equalTo(logoImage.snp.centerY)
        }
        
        let infoStackInsets = UIEdgeInsets(bottom: 16, horizontal: 16)
        infoStsck.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(infoStackInsets)
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
