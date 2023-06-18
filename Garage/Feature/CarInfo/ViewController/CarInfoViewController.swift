//
//  CarInfoViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//  
//

import UIKit

class CarInfoViewController: BasicViewController {

    // - UI
    typealias Coordinator = CarInfoControllerCoordinator
    typealias Layout = CarInfoControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    var coordinator: Coordinator!
    private var layout: Layout!
    
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.5
    public var animationDuration: TimeInterval = 0.2
    
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
        makeCloseButton(isLeft: true)
        scroll.delegate = self
        view.backgroundColor = AppColors.background
        title = "Общая информация"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.readCar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.recordsView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(layout.topStack.frame.height + 21)
            make.leading.trailing.equalToSuperview()
        }
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

extension CarInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableVM.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recordCell = tableView.dequeueReusableCell(BasicTableCell<RecordView>.self, for: indexPath),
              let item = vm.tableVM.cells[safe: indexPath.row]
        else { return .init() }
        recordCell.mainView.setViewModel(.init(record: item))
        return recordCell
    }
}

extension CarInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
    }
}

extension CarInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView)
        
        let profileNameLabelScale = min(2.0, max(1.0 - offset / -500.0, 1.0))
        let profileViewsLabelScale = min(max(1.0 - offset / 400.0, 0.0), 1.0)
        let profileViewsAlphaScale = min(max(1.0 - offset / 120.0, 0.0), 1.0)

        
        print(profileNameLabelScale)
        layout.topStack.anchorPoint = CGPoint(x: <#T##Double#>, y: <#T##Double#>)
        layout.topStack.frame.origin = CGPoint(x: 0, y: profileNameLabelScale)
       
        layout.topStack.transform = CGAffineTransform(scaleX: 1, y: profileNameLabelScale)
        
    }
}

