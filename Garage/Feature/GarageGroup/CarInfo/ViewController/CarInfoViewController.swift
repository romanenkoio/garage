//
//  CarInfoViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//  
//

import UIKit
import SnapKit

class CarInfoViewController: BasicViewController {

    // - UI
    typealias Coordinator = CarInfoControllerCoordinator
    typealias Layout = CarInfoControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    var coordinator: Coordinator!
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
        hideNavBar(false)
        hideTabBar(true)
        makeCloseButton(isLeft: true)
        scroll.delegate = self
        title = "Общая информация"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readCar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.maxConstraintConstant = layout.topStack.frame.size.height + 40
    }
    
    override func hideKeyboard() {
        super.hideKeyboard()
        self.vm.addButtonVM.isOpen = false
    }
    
    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    
    override func binding() {
        layout.brandModelLabel.setViewModel(vm.brandLabelVM)
        layout.yearLabel.setViewModel(vm.yearLabelVM)
        layout.mileageLabel.setViewModel(vm.milageLabelVM)
        layout.vinLabel.setViewModel(vm.vinLabelVM)
        layout.segment.setViewModel(vm.segmentVM)
        layout.addButton.setViewModel(vm.addButtonVM)
        layout.topStack.setViewModel(vm.topStackVM)
        
        vm.addButtonVM.actions = [
            .init(text: "Добавить запись", action: { [weak self] in
                guard let self else { return }
                coordinator.navigateTo(CarInfoNavigationRoute.createRecord(vm.car))
            }),
            .init(text: "Запланировать", action: { [weak self] in
                guard let self else { return }
                coordinator.navigateTo(CarInfoNavigationRoute.createReminder(vm.car))
            })
        ]
        
        vm.pageVM.$index.sink { index in
            self.vm.pageVM.controllers[index].tableView.delegate = self
            self.scroll.isScrollEnabled = !self.vm.pageVM.controllers[index].tableView.visibleCells.isEmpty
        }
        .store(in: &cancellables)
    }
}

// MARK: -
// MARK: - Configure

extension CarInfoViewController {

    private func configureCoordinator() {
        coordinator = CarInfoControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CarInfoControllerLayoutManager(vc: self)
    }
}

extension CarInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch vm.segmentVM.selectedItem {
            
        case .paste:
            guard let record = vm.pastRecordsVM.tableVM.cells[safe: indexPath.row] else { return }
            coordinator.navigateTo(CarInfoNavigationRoute.editRecord(vm.car, record))
         
        case .future:
            break
        }
    }
}

extension CarInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffsetY = scrollView.contentOffset.y
        let scrollDiff = currentContentOffsetY - layout.previousContentOffsetY
        
        // Верхняя граница начала bounce эффекта
        let bounceBorderContentOffsetY = -scrollView.contentOffset.y
        
        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY
        
        if let currentScrollConstraintConstant = layout.animatedScrollConstraint?.layoutConstraints.first?.constant,
           let maxConstraintConstant = layout.maxConstraintConstant {
            var newConstraintConstant = currentScrollConstraintConstant
            
            if contentMovesUp {
                // Уменьшаем константу констрэйнта
                newConstraintConstant = max(currentScrollConstraintConstant - scrollDiff, layout.scrollMinConstraintConstant)
                
                if newConstraintConstant < maxConstraintConstant , !self.vm.pageVM.controllers[self.vm.pageVM.index].tableView.visibleCells.isEmpty {
                    self.layout.animatedScrollConstraint?.update(offset: layout.scrollMinConstraintConstant)
                    self.scroll.contentOffset.y = self.layout.previousContentOffsetY
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        if scrollView == self.scroll {
                            self.scroll.isScrollEnabled = false
                            self.vm.pageVM.controllers[self.vm.pageVM.index].tableView.isScrollEnabled = true
                        }
                    }
                }
                
            } else if contentMovesDown {
                newConstraintConstant = min(currentScrollConstraintConstant - scrollDiff, maxConstraintConstant)
                
                if newConstraintConstant >= maxConstraintConstant / 2 {
                    self.layout.animatedScrollConstraint?.update(offset: maxConstraintConstant)
                    self.scroll.contentOffset.y = self.layout.previousContentOffsetY
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                        self.scroll.isScrollEnabled = true
                        self.vm.pageVM.controllers[self.vm.pageVM.index].tableView.isScrollEnabled = false
                    }
                }
            }
            
            //Процент завершения анимации
            //            let animationCompletionPercent = ((layout.maxConstraintConstant ?? 0) - currentScrollConstraintConstant) / ((layout.maxConstraintConstant ?? 0) - layout.scrollMinConstraintConstant)
            //            layout.previousContentOffsetY = scrollView.contentOffset.y
        }
    }
}
