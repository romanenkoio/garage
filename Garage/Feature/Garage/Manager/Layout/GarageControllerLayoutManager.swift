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
        
    lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(CarCell.self)
        table.dataSource = vc
        table.delegate = vc
        table.separatorStyle = .none
        return table
    }()
    
    lazy var animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.animation = .named("garage")
        view.animationSpeed = 1
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1
        return view
    }()
    
    lazy var addCarButton = BasicButton()
    
    // - Init
    init(vc: GarageViewController) {
        self.vc = vc
        configure()
        animationView.play()
        
        let addButtonVM = NavBarButton.ViewModel(
            action: .touchUpInside {
                vc.coordinator.navigateTo(GarageNavigationRoute.createCar)
            },
            image: UIImage(systemName: "plus")
        )
        vc.makeRightNavBarButton(buttons: [addButtonVM])
    }
    
    func checkEmptyTable() {
        addCarButton.isHidden = !vc.vm.cells.isEmpty
        animationView.isHidden = !vc.vm.cells.isEmpty
        table.isHidden = vc.vm.cells.isEmpty
        vc.vm.cells.isEmpty ? animationView.play() : animationView.pause()
        table.reloadData()
        vc.hideNavBar(vc.vm.cells.isEmpty )
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
        vc.view.addSubview(table)
        vc.view.addSubview(animationView)
        vc.view.addSubview(addCarButton)
        vc.contentView.isHidden = true
    }
    
    private func makeConstraint() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.center.equalTo(vc.view)
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        let buttonInset = UIEdgeInsets(horizontal: 16)
        addCarButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(buttonInset)
            make.top.equalTo(animationView.snp.bottom)
        }
    }
}
