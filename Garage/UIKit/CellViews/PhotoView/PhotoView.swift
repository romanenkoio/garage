//
//  PhotoView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 13.06.23.
//

import UIKit

class PhotoView: BasicView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override func initView() {
        makeLayout()
        makeConstraints()
        self.isUserInteractionEnabled = true
    }
    
    private func makeLayout() {
        addSubview(imageView)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        vm.$image.sink { [weak self] image in
            self?.imageView.image = image
        }
        .store(in: &cancellables)
    }
}

