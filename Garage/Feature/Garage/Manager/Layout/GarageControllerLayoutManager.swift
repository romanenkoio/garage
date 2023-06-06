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
        let table = UITableView()
        table.register(CarCell.self)
        table.dataSource = vc
        table.delegate = vc
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
    }
    
    func checkEmptyTable() {
        addCarButton.isHidden = !vc.vm.cells.isEmpty
        animationView.isHidden = !vc.vm.cells.isEmpty
        table.isHidden = vc.vm.cells.isEmpty
        vc.vm.cells.isEmpty ? animationView.play() : animationView.pause()
        vc.contentView.isHidden = vc.vm.cells.isEmpty
        table.reloadData()
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
        vc.contentView.addSubview(table)
        vc.view.addSubview(animationView)
        vc.view.addSubview(addCarButton)
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
