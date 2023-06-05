//
//  ErrorView.swift
//  Logogo
//
//  Created by Illia Romanenko on 17.05.23.
//

import UIKit

class ErrorView: BasicView {
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .custom(size: 12, weight: .light)
        label.textColor = .additionalRed
        return label
    }()

    lazy var infoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle")
        imageView.tintColor = .additionalRed
        return imageView
    }()

    private(set) weak var vm: ViewModel?

    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        super.initView()
        backgroundColor = .clear
        layoutElements()
        makeConstraints()
    }

    private func layoutElements() {
        addSubview(infoView)
        addSubview(errorLabel)
    }

    private func makeConstraints() {
        infoView.snp.makeConstraints { make in
            make.height.width.equalTo(15)
            make.leading.top.bottom.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.leading.equalTo(infoView.snp.trailing).offset(5)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
    
    func setViewModel(vm: ErrorView.ViewModel) {
        self.vm = vm
        vm.$image.sink { [weak self] errorImage in
            self?.infoView.image = errorImage
        }
        .store(in: &cancellables)
        
        vm.$error.sink { [weak self] value in
            self?.errorLabel.text = value
        }
        .store(in: &cancellables)
    }
}
