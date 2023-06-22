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
        hideTabBar(false)
        makeCloseButton(isLeft: true)
        scroll.delegate = self
        view.backgroundColor = AppColors.background
        title = "Общая информация"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readCar()
        layout.table.table.reloadData()
        layout.table.table.isScrollEnabled = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.remakeConstraintsAfterLayout()
        layout.maxConstraintConstant = layout.topStack.frame.size.height
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
        layout.addRecordButton.setViewModel(vm.addButtonVM)
        
        vm.addButtonVM.buttonVM.action = .touchUpInside { [weak self] in
            guard let self else { return }
            coordinator.navigateTo(CarInfoNavigationRoute.createRecord(vm.car))
        }
        
        vm.$logo.sink { [weak self] logo in
            self?.layout.logoImage.image = logo
        }
        .store(in: &cancellables)
        
        vm.pageVM.$index.sink { index in
            
        }
        .store(in: &cancellables)
        
        vm.$srollViewValue.sink { value in
            self.scroll.isScrollEnabled = value
            print(self.scroll.isScrollEnabled)
        }
        .store(in: &cancellables)
    }
    var layputOnce = true
    var layputOnceAgain = true
    
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

extension CarInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return vm.tableVM.cells.count
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recordCell = tableView.dequeueReusableCell(BasicTableCell<RecordView>.self, for: indexPath)
              
        else { return .init() }
        let vm = RecordView.ViewModel(record: .testRecord)
        recordCell.mainView.setViewModel(vm)
        
        return recordCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CarInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
}

extension CarInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        var offset = scrollView.contentOffset.y
//
//        let translation = scrollView.panGestureRecognizer.translation(in: scrollView)
//
//        let stackScale = min(1.0, max(0.5 - offset / -10000.0, 0.5))
//        let profileViewsLabelScale = min(max(1.0 - offset / 400.0, 0.0), 1.0)
//        let profileViewsAlphaScale = min(max(0.5 - offset / 120.0, 0.0), 0.5)
        
        let currentContentOffsetY = scrollView.contentOffset.y
        let scrollDiff = currentContentOffsetY - layout.previousContentOffsetY

        // Верхняя граница начала bounce эффекта
        let bounceBorderContentOffsetY = -scrollView.contentOffset.y
        
        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY
        
        if let currentScrollConstraintConstant = layout.animatedScrollConstraint?.layoutConstraints.first?.constant,
           let currentSegmentTopConstraintConstant = layout.animatedSegmentTopConstaint?.layoutConstraints.first?.constant {
            
            var newConstraintConstant = currentScrollConstraintConstant
            var newSegmentConstraintConstant = currentSegmentTopConstraintConstant
            
            if contentMovesUp {
                // Уменьшаем константу констрэйнта
                newConstraintConstant = max(currentScrollConstraintConstant - scrollDiff, layout.scrollMinConstraintConstant)
                newSegmentConstraintConstant = max(currentSegmentTopConstraintConstant - scrollDiff, layout.segmentMinConstraintConstant)
                
                if newConstraintConstant == 0, layputOnceAgain  {
                    scrollView.isScrollEnabled = false
                    vm.tableViewValue = true
                    layout.remakeScrollConstraintsAgain()
                    layputOnce = true
                    layputOnceAgain = false
                }
            } else if contentMovesDown {
                // Увеличиваем константу констрэйнта
                newSegmentConstraintConstant = min(currentSegmentTopConstraintConstant - scrollDiff, layout.maxConstraintConstant ?? 0)
                newConstraintConstant = min(currentScrollConstraintConstant - scrollDiff, layout.maxConstraintConstant ?? 0)
                
                if newConstraintConstant == layout.topStack.frame.size.height, layputOnce  {
                    layout.remakeScrollConstraints()
                    layputOnce = false
                    layputOnceAgain = true
                }
            }
            
            // Меняем высоту и запрещаем скролл, только в случае изменения константы
            if newConstraintConstant != currentScrollConstraintConstant {
                layout.animatedScrollConstraint?.update(offset: newConstraintConstant)
                layout.animatedSegmentTopConstaint?.update(offset: newSegmentConstraintConstant)
                scrollView.contentOffset.y = layout.previousContentOffsetY
            }
            
            //Процент завершения анимации
            let animationCompletionPercent = ((layout.maxConstraintConstant ?? 0) - currentScrollConstraintConstant) / ((layout.maxConstraintConstant ?? 0) - layout.scrollMinConstraintConstant)
            layout.previousContentOffsetY = scrollView.contentOffset.y
            
        }

    }
}

