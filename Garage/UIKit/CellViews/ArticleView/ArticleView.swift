//
//  ArticleView.swift
//  Garage
//
//  Created by Illia Romanenko on 27.06.23.
//

import UIKit

class ArticleView: BasicStackView {
    private lazy var imageView: BasicImageView = {
        let view = BasicImageView()
        view.contentMode = .scaleAspectFill
        view.cornerRadius = 20
        return view
    }()
    
    private lazy var title: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 16, weight: .black)
        label.textInsets = .init(top: 10, bottom: 10, horizontal: 8)
        return label
    }()
    
    private(set) lazy var readedLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 16, weight: .medium)
        label.textInsets = .init(top: 10, bottom: 10, horizontal: 8)
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.cornerRadius = 12
        label.textColor = AppColors.green
        return label
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
        self.axis = .vertical
        self.clipsToBounds = true
        self.edgeInsets = .init(top: 5, bottom: 5, horizontal: 21)
    }
    
    private func makeLayout() {
        self.addArrangedSubviews([imageView, title])
        self.addSubview(readedLabel)
    }
    
    private func makeConstraint() {
        imageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        readedLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(imageView).inset(UIEdgeInsets(top: 10, right: 10))
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        title.setViewModel(vm.titleVM)
        imageView.setViewModel(vm.imageVM)
        readedLabel.setViewModel(vm.readedLabelVM)
    }
}
