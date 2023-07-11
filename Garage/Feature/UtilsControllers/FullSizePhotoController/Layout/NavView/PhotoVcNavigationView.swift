//
//  PhotoVcNavigationView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 13.06.23.
//

import UIKit

class PhotoVcNavigationView: BasicView {
    private lazy var photoCountLabel: BasicLabel = {
        let label = BasicLabel()
        label.textColor = .white
        //label.font = .custom(size: 16, weight: .semibold)
        return label
    }()
    
    private lazy var closeButton: BasicButton = {
        let btn = BasicButton()
       // btn.titleLabel?.font = .custom(size: 16, weight: .medium)
        return btn
    }()
    
    lazy var shareButton = BasicButton()
    
    private(set) var viewModel: ViewModel?
    
    override init() {
        super.init()
        makeLayout()
        makeConstraints()
        cornerRadius = 0
        backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(photoCountLabel)
        addSubview(closeButton)
        addSubview(shareButton)
    }
    
    private func makeConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        photoCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        closeButton.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalTo(photoCountLabel)
        }
        
        shareButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(photoCountLabel)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.viewModel = vm
        if let photoCountLabelVM = vm.photoCountLabelVM {
            photoCountLabel.setViewModel(photoCountLabelVM)
        }
        
        if let closeButtonVM = vm.closeButtonVM {
            closeButton.setViewModel(closeButtonVM)
        }
        
        if let shareButtonVM = vm.shareButtonVM {
            shareButton.setViewModel(shareButtonVM)
        }
        
        vm.$isHidden
            .sink {[weak self] in
                if let value = $0 { self?.isHidden = value }
            }
            .store(in: &cancellables)
    }
}
