//
//  PremiumControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 28.07.23.
//  
//

import UIKit
import SnapKit

final class PremiumControllerLayoutManager {
    
    private unowned let vc: PremiumViewController
    
    private(set) lazy var toplabel = BasicLabel()
    private(set) lazy var logoImage = BasicImageView()
    private(set) lazy var closeImage = ActionImage()
    private(set) lazy var startTrialButton = BasicButton()
    
    
    private lazy var bottomStack: BasicStackView = {
        let stack = BasicStackView()
        stack.spacing = 8
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private(set) lazy var restoreLabel: TappableLabel = {
        let label = TappableLabel()
        label.font = .custom(size: 12, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private(set) lazy var termsLabel: TappableLabel = {
        let label = TappableLabel()
        label.font = .custom(size: 12, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private(set) lazy var privacyLabel: TappableLabel = {
        let label = TappableLabel()
        label.font = .custom(size: 12, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var featuresLabel: BasicLabel = {
        let label = BasicLabel()
        label.textColor = .white
        label.font = .custom(size: 16, weight: .bold)
        label.text = "И получи доступ ко всем функциям:"
        return label
    }()
    
    private lazy var featuresStack: BasicStackView = {
        let stack = BasicStackView()
        stack.spacing = 8
        stack.edgeInsets = .init(top: 8)
        return stack
    }()
    
    private lazy var separator = SeparatorView()
    
    private lazy var plansStack: BasicStackView = {
       let stack = BasicStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        return stack
    }()
    
    // - Init
    init(vc: PremiumViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension PremiumControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.disableScrollView()
        vc.contentView.backgroundColor = UIColor(hexString: "#344ECC")
        vc.view.backgroundColor = UIColor(hexString: "#344ECC")
        vc.contentView.addSubview(logoImage)
        vc.contentView.addSubview(toplabel)
        vc.contentView.addSubview(closeImage)
        vc.contentView.addSubview(separator)
        vc.contentView.addSubview(featuresLabel)
        vc.contentView.addSubview(featuresStack)
        
        PremiumFeatures.allCases.forEach { [weak self] feature in
            let label = BasicLabel(font: .custom(size: 14, weight: .semibold))
            label.text = feature.title
            label.textInsets = .init(bottom: 8)
            label.textColor = .white
            self?.featuresStack.addArrangedSubview(label)
        }
        
        vc.contentView.addSubview(plansStack)
     
        vc.contentView.addSubview(startTrialButton)
        vc.contentView.addSubview(bottomStack)
        bottomStack.addArrangedSubviews([restoreLabel, termsLabel, privacyLabel])
        
        vc.vm.$plans.sink { [weak self] plansVM in
            let width = (UIScreen.main.bounds.width - 52) / 3
            plansVM.forEach { [weak self] plan in
                let planView = SelectPlanView()
                planView.setViewModel(plan)
                planView.snp.makeConstraints { make in
                    make.width.equalTo(width)
                    make.height.equalTo(width * 1.2)
                }
                self?.plansStack.addArrangedSubview(planView)
            }
        }
        .store(in: &vc.cancellables)
        
        vc.vm.plans.forEach { [weak self] plan in
            guard let self else { return }
            plan.selectedSubject.sink { [weak self] vm in
                guard let self else { return }
                self.vc.vm.plans.forEach({ $0.isSelected = $0 === vm } )
            }
            .store(in: &vc.cancellables)
        }
      
    }
    
    private func makeConstraint() {
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(UIEdgeInsets(top: 9))
        }
    
        closeImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIEdgeInsets(left: 20))
            make.centerY.equalTo(logoImage)
        }
        
        toplabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 20))
        }
        
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 20))
            make.top.equalTo(toplabel.snp.bottom).offset(16)
        }
        
        featuresLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 26))
            make.top.equalTo(separator.snp.bottom).offset(16)
        }
        
        featuresStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 26))
            make.top.equalTo(featuresLabel.snp.bottom).offset(12)
        }
        
        plansStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 20))
            make.top.greaterThanOrEqualTo(featuresStack.snp.bottom)
        }
        
        startTrialButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 20))
            make.top.equalTo(plansStack.snp.bottom).offset(54)
        }
        
        bottomStack.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(horizontal: 20))
            make.top.equalTo(startTrialButton.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-25)
        }
    }
    
}
