//
//  OnboardingView.swift
//  Garage
//
//  Created by Illia Romanenko on 3.07.23.
//

import UIKit

class OnboardingView: BasicView {
    private lazy var onboardingImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var titleLabel = BasicLabel(font: .custom(size: 22, weight: .heavy))
    lazy var subtitleLabel = BasicLabel(font: .custom(size: 16, weight: .bold))

    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(onboardingImage)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        titleLabel.textInsets = .init(top: 5, bottom: 5, horizontal: 20)
        subtitleLabel.textInsets = .init(bottom: 15, horizontal: 20)
        subtitleLabel.textColor = UIColor(hexString: "#ADADAD")
        titleLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        subtitleLabel.numberOfLines = 0
    }
    
    private func makeConstraint() {
        onboardingImage.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(onboardingImage.snp.bottom)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        subtitleLabel.setViewModel(vm.subtitleVM)
        titleLabel.setViewModel(vm.titleVM)
        
        vm.$image.sink { [weak self] image in
            self?.onboardingImage.image = image
        }
        .store(in: &cancellables)
    }
}
