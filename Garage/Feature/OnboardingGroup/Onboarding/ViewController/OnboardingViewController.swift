//
//  OnboardingViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 3.07.23.
//  
//

import UIKit

class OnboardingViewController: BasicViewController {

    // - UI
    typealias Coordinator = OnboardingControllerCoordinator
    typealias Layout = OnboardingControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: Coordinator!
    private var layout: Layout!
    
    init(vm: ViewModel = .init()) {
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
        layout.nextButton.setViewModel(vm.nextButton)
        layout.collectionView.setViewModel(vm.collectionVM)
        layout.skipLabel.setViewModel(vm.skipLabelVM)
        
        vm.collectionVM.$cells.sink { [weak self] _ in
            self?.layout.collectionView.reload()
        }
        .store(in: &cancellables)
        
        vm.closeCompletion = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
}

// MARK: -
// MARK: - Configure

extension OnboardingViewController {

    private func configureCoordinator() {
        coordinator = OnboardingControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = OnboardingControllerLayoutManager(vc: self)
    }
    
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.collectionVM.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let point = vm.collectionVM.cells[safe: indexPath.row],
              let onboardingCell = collectionView.dequeueReusableCell(BasicCollectionCell<OnboardingView>.self, for: indexPath) else { return UICollectionViewCell() }
        
        onboardingCell.mainView.setViewModel(.init(type: point))
        return onboardingCell
    }
}

extension OnboardingViewController: UICollectionViewDelegate {
    
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
