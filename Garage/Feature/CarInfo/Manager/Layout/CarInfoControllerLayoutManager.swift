//
//  CarInfoControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//  
//

import UIKit
import SnapKit

final class CarInfoControllerLayoutManager {
    
    private unowned let vc: CarInfoViewController
    
    lazy var topStack: BasicStackView = {
        let view = BasicStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.cornerRadius = 12
        view.spacing = 10
        view.paddingInsets = .init(left: 20)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var logoImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.cornerRadius = 39
        return view
    }()
    
    lazy var brandModelLabel = BasicLabel()
    lazy var yearLabel = BasicLabel()
    lazy var vinLabel = BasicLabel()
    lazy var mileageLabel = BasicLabel()
    lazy var segment = BasicSegmentView<RecordType>()
    
    // - Init
    init(vc: CarInfoViewController) {
        self.vc = vc
        configure()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CarInfoControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(topStack)
        topStack.addArrangedSubviews([
            logoImage,
            brandModelLabel,
            mileageLabel,
            yearLabel,
            vinLabel
        ])
        vc.contentView.addSubview(segment)
        
        brandModelLabel.font = .custom(size: 18, weight: .black)
        yearLabel.font = .custom(size: 14, weight: .bold)
        vinLabel.font = .custom(size: 14, weight: .bold)
        mileageLabel.font = .custom(size: 14, weight: .bold)
    }
    
    private func makeConstraint() {
        logoImage.snp.makeConstraints { make in
            make.height.width.equalTo(78)
        }
        
        topStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        segment.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
