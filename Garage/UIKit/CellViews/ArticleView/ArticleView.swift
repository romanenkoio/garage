//
//  ArticleView.swift
//  Garage
//
//  Created by Illia Romanenko on 27.06.23.
//

import UIKit

class ArticleView: BasicStackView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "test_article")
        view.cornerRadius = 20
        return view
    }()
    
    private lazy var title: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 16, weight: .black)
        label.textInsets = .init(top: 10, bottom: 10, horizontal: 8)
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
    }
    
    private func makeConstraint() {
        imageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        title.setViewModel(vm.titleVM)
        
        vm.$image.compactMap().sink { [weak self] image in
            self?.imageView.image = image
        }
        .store(in: &cancellables)
    }
}
