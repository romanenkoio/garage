//
//  DetailsView.swift
//  Garage
//
//  Created by Illia Romanenko on 21.06.23.
//

import Foundation
import UIKit

class DetailsView: BasicView {

    private lazy var detailsLabel: BasicLabel = {
        let label = BasicLabel()
        label.textInsets = .init(top: 24, bottom: 24, left: 24)
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = AppColors.blue
        return label
    }()
    
    private lazy var detailsImage = UIImageView()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(detailsLabel)
        self.addSubview(detailsImage)
        self.backgroundColor = UIColor(hexString: "#EDEDED")
    }
    
    private func makeConstraint() {
        self.snp.makeConstraints { make in
            self.snp.makeConstraints { make in
                make.height.equalTo(68)
            }
        }
        
        detailsLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        detailsImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.centerY.trailing.equalToSuperview().inset(UIEdgeInsets(right: 24))
            make.leading.greaterThanOrEqualTo(detailsLabel.snp.trailing)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        detailsImage.image = vm.image
        detailsLabel.setViewModel(vm.labelVM)
    }
}
