//
//  PaymentView.swift
//  Logogo
//
//  Created by Illia Romanenko on 20.05.23.
//

import UIKit

class PaymentView: BasicView {
    
    private lazy var dotImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_right_chevron")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var separator: BasicView = {
        let view = BasicView()
        view.backgroundColor = .systemGray5
        view.cornerRadius = 0
        return view
    }()
    
    private lazy var dateLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 17, weight: .medium)
        label.textInsets = .init(top: 17, bottom: 17, left: 10)
        return label
    }()
    
    private lazy var nameLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 17, weight: .medium)
        label.textInsets = .init(top: 17, bottom: 17)
        return label
    }()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        makeLayout()
        makeConstrains()
    }
    
    private func makeLayout() {
        self.addSubview(dateLabel)
        self.addSubview(nameLabel)
        self.addSubview(dotImage)
        self.addSubview(separator)
    }
    
    private func makeConstrains() {
        let dotInset = UIEdgeInsets(left: 20)
        dotImage.snp.makeConstraints { make in
            make.height.width.equalTo(10)
            make.leading.centerY.equalToSuperview().inset(dotInset)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(separator.snp.top)
            make.leading.equalTo(dotImage.snp.trailing)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing)
            make.top.equalToSuperview()
            make.bottom.equalTo(separator.snp.top)
            make.trailing.greaterThanOrEqualToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        dateLabel.setViewModel(vm.dateLabelVM)
        nameLabel.setViewModel(vm.nameLabelVM)
        
        vm.$isLast
            .sink { [weak self] in self?.separator.isHidden = $0 }
            .store(in: &cancellables)
    }
}
