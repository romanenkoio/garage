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
        view.alignment = .center
        view.cornerRadius = 12
        view.spacing = 10
        view.backgroundColor = .primaryPink.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var logoImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.cornerRadius = 50
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
        
        let trashButtonVM = NavBarButton.ViewModel(
            action: .touchUpInside {
//                vc.coordinator.navigateTo(GarageNavigationRoute.createCar)
            },
            image: UIImage(systemName: "trash")
        )
        vc.makeRightNavBarButton(buttons: [trashButtonVM])
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
            yearLabel,
            vinLabel,
            mileageLabel
        ])
        vc.contentView.addSubview(segment)
    }
    
    private func makeConstraint() {
        logoImage.snp.makeConstraints { make in
            make.height.width.equalTo(100)
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
