//
//  ParkingMapControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 24.07.23.
//  
//

import UIKit
import SnapKit
import GoogleMaps

final class ParkingMapControllerLayoutManager {
    
    private unowned let vc: ParkingMapViewController
    
    lazy var mapView: GMSMapView = {
        let view = GMSMapView()
        view.isMyLocationEnabled = true
        return view
    }()
    
    // - Init
    init(vc: ParkingMapViewController) {
        self.vc = vc
        configure()
    }
}

// MARK: -
// MARK: - Configure

fileprivate extension ParkingMapControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.disableScrollView()
        vc.contentView.addSubview(mapView)
    }
    
    private func makeConstraint() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
