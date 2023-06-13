//
//  GarageControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import SnapKit
import Lottie

final class GarageControllerLayoutManager {
    private unowned let vc: GarageViewController
    
    lazy var table: BasicTableView = {
        let table = BasicTableView()
        table.setupTable(
            dataSource: vc,
            delegate: vc
        )
        table.register(CarCell.self)
        table.table.separatorColor = .clear
        return table
    }()

    // - Init
    init(vc: GarageViewController) {
        self.vc = vc
        configure()
        
        let addButtonVM = NavBarButton.ViewModel(
            action: .touchUpInside {
                vc.coordinator.navigateTo(GarageNavigationRoute.createCar)
            },
            image: UIImage(systemName: "plus")
        )
        vc.makeRightNavBarButton(buttons: [addButtonVM])
    }
}

// MARK: -
// MARK: - Configure

fileprivate extension GarageControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.disableScrollView()
        vc.contentView.addSubview(table)
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
