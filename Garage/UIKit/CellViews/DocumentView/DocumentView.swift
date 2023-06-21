//
//  DocumentView.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import Foundation
import UIKit

class DocumentView: BasicView {
    
    
    private lazy var stack: BasicStackView = {
       let stack = BasicStackView()
        stack.spacing = 5
        stack.axis = .vertical
        stack.cornerRadius = 12
        stack.backgroundColor = UIColor(hexString: "EFEFEF")
        stack.edgeInsets = .init(vertical: 12, horizontal: 21)
        return stack
    }()
    
    private lazy var typeLabel = BasicLabel()
    private lazy var dateLabel = BasicLabel()
    private lazy var photoList = BasicImageListView()
    private lazy var photoListContainerView: BasicView = {
        let view = BasicView()
        view.cornerRadius = 0
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var detailsView = DetailsView()

    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        photoListContainerView.addSubview(photoList)
        stack.addArrangedSubviews([
            typeLabel,
            dateLabel,
            photoListContainerView,
            detailsView
        ])

        typeLabel.font = .custom(size: 18, weight: .black)
        typeLabel.textColor = .black
        
        dateLabel.font = .custom(size: 14, weight: .semibold)
        dateLabel.textColor = UIColor(hexString: "939393")

        typeLabel.textInsets = .init(top: 24, horizontal: 24)
        dateLabel.textInsets = .init(horizontal: 24)
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        photoList.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(UIEdgeInsets(bottom: 16))
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        typeLabel.setViewModel(vm.typeLabelVM)
        dateLabel.setViewModel(vm.dateLabelVM)
        photoList.setViewModel(vm.photoListVM)
        detailsView.setViewModel(vm.detailVM)
    }
}
