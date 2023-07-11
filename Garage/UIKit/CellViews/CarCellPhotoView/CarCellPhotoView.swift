//
//  CarCellPhotoView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.07.23.
//

import UIKit

class CarCellPhotoView: BasicView {
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.cornerRadius = 16
        return view
    }()
    
    private(set) var viewModel: ViewModel?
    
    override init() {
        super.init()
        makeLayout()
        makeConstraints()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(imageView)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: 8))
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.viewModel = vm
        vm.$image
            .sink { [weak self] in self?.imageView.image = $0 }
            .store(in: &cancellables)

    }
}
