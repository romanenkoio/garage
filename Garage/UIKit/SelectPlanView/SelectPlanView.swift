//
//  SelectPlanView.swift
//  Garage
//
//  Created by Illia Romanenko on 28.07.23.
//

import UIKit

class SelectPlanView: BasicView {
    
    private lazy var selectView = BasicView()

    private lazy var periodLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .center
        label.textColor = AppColors.blue
        label.font = .custom(size: 16, weight: .extrabold)
        return label
    }()
    
    private lazy var priceLabel: BasicLabel = {
        let label = BasicLabel()
        label.textColor = .black
        label.font = .custom(size: 13, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textInsets = UIEdgeInsets(left: 10, right: 10)
        return label
    }()
    
    private lazy var cancelLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 10, weight: .semibold)
        label.textColor = UIColor(hexString: "#858585")
        label.textAlignment = .center
        label.textInsets = UIEdgeInsets(bottom: 12, left: 10, right: 10)
        return label
    }()
    
    private weak var vm: ViewModel!
    
    override func initView() {
        makeLayout()
        makeConstraint()
        setupGesture()
        isUserInteractionEnabled = true
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectAction))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func selectAction() {
        vm.isSelected = true
        vm.selectedSubject.send(self.vm)
    }
    
    private func makeLayout() {
        self.addSubview(selectView)
        self.addSubview(periodLabel)
        self.addSubview(priceLabel)
        self.addSubview(cancelLabel)
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.cornerRadius = 12
        selectView.cornerRadius = 0
    }
    
    private func makeConstraint() {
        selectView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(34)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.edges.equalTo(selectView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        cancelLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        
        periodLabel.setViewModel(vm.periodLabelVM)
        priceLabel.setViewModel(vm.priceLabelVM)
        cancelLabel.setViewModel(vm.cancelLabelVM)
        
        vm.$isSelected.sink { [weak self] value in
            self?.selectView.backgroundColor = value ? UIColor(hexString: "#33BC4A") : .clear
            self?.periodLabel.textColor = value ? .white : AppColors.blue
        }
        .store(in: &cancellables)
    }
}
