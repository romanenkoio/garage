//
//  FeatureRecordsViewController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 19.06.23.
//  
//

import UIKit

class FeatureRecordsViewController: BasicViewController {

    // - UI
    typealias Coordinator = FeatureRecordsControllerCoordinator
    typealias Layout = FeatureRecordsControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: Coordinator!
    private var layout: Layout!
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        
    }
    
}

// MARK: -
// MARK: - Configure

extension FeatureRecordsViewController {

    private func configureCoordinator() {
        coordinator = FeatureRecordsControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = FeatureRecordsControllerLayoutManager(vc: self)
    }
    
}
