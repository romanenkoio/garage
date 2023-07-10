//
//  ActionImage.swift
//  Garage
//
//  Created by Illia Romanenko on 8.06.23.
//

import UIKit

final class ActionImage: BasicView {
    
    private weak var vm: ViewModel?
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(imageView)
    }
    
    private func makeConstraint() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.vm = vm
    
        vm.$image.sink { [weak self] image in
            self?.imageView.image = image
        }
        .store(in: &cancellables)
        
        vm.$isEnabled.sink { [weak self] value in
            self?.alpha = value ? 1 : 0.5
            self?.isUserInteractionEnabled = value
        }
        .store(in: &cancellables)
        
        vm.$action.sink { [weak self] _ in
            guard let self else { return }
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(self.tapAction)
            )
            self.imageView.addGestureRecognizer(tap)
        }
        .store(in: &cancellables)
    }
    
    @objc private func tapAction() {
        self.vm?.action()
    }
}
