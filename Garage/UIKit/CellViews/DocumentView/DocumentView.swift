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
    
    private lazy var detailsView: BasicView = {
        let stack = BasicView()
        stack.backgroundColor = UIColor(hexString: "0C0C0C").withAlphaComponent(0.08)
        stack.cornerRadius = 0
        return stack
    }()
    
    private lazy var detailsLabel = BasicLabel()
    private lazy var detailsImage = UIImageView()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(stack)
        photoListContainerView.addSubview(photoList)
        stack.addArrangedSubviews([typeLabel, dateLabel, photoListContainerView, detailsView])
      
        detailsView.addSubview(detailsLabel)
        detailsView.addSubview(detailsImage)
        
        typeLabel.font = .custom(size: 18, weight: .black)
        typeLabel.textColor = .black
        
        dateLabel.font = .custom(size: 14, weight: .semibold)
        dateLabel.textColor = UIColor(hexString: "939393")
        detailsImage.image = UIImage(named: "arrow_right_ic")?.withTintColor(ColorScheme.standartBlue.buttonColor)
        typeLabel.textInsets = .init(top: 24, horizontal: 24)
        dateLabel.textInsets = .init(horizontal: 24)
        detailsLabel.textInsets = .init(top: 24, bottom: 24, left: 24)
        detailsLabel.font = .custom(size: 14, weight: .semibold)
        detailsLabel.textColor = ColorScheme.standartBlue.buttonColor
    }
    
    private func makeConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        photoList.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(UIEdgeInsets(bottom: 16))
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        detailsImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.centerY.trailing.equalToSuperview().inset(UIEdgeInsets(right: 24))
            make.leading.greaterThanOrEqualTo(detailsLabel.snp.trailing)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        typeLabel.setViewModel(vm.typeLabelVM)
        dateLabel.setViewModel(vm.dateLabelVM)
        photoList.setViewModel(vm.photoListVM)
        detailsLabel.setViewModel(vm.detailsLabelVM)
    }
}
