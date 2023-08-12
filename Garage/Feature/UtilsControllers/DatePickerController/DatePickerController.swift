//
//  DatePickerController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 24.07.23.
//

import UIKit
import SnapKit
import Combine

class DatePickerController: UIViewController {
    private var vm: ViewModel
    private var cancellables = Set<AnyCancellable>()
    
    lazy var contentView: BasicView = {
        let view = BasicView()
        return view
    }()
    
    lazy private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.locale = Locale.current
        return picker
    }()
    
    lazy private var saveButton: BasicButton = {
        let button = BasicButton()
        return button
    }()
    
    lazy private var closeButton = NavBarButton()
    
    lazy private var separateView: SeparatorView = {
        let view = SeparatorView()
        view.backgroundColor = .init(hexString: "#E3E3E3")
        return view
    }()
    
    lazy private var descriptionLabel: BasicLabel = {
        let label = BasicLabel()
        label.textInsets = UIEdgeInsets(vertical: 16)
        return label
    }()
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
        makeLayout()
        makeConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        sheetPresent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            vm.isBeingDismissed.toggle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        view.addSubview(contentView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(separateView)
        contentView.addSubview(datePicker)
        contentView.addSubview(saveButton)
        
        descriptionLabel.font = .custom(size: 16, weight: .bold)
    }
    
    private func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(34)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(8)
        }
        
        separateView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            make.height.equalTo(260)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 60))
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func sheetPresent() {
        if let presentationController = presentationController as? UISheetPresentationController {
    
            presentationController.selectedDetentIdentifier = .medium
            presentationController.accessibilityElementsHidden = true
            presentationController.prefersEdgeAttachedInCompactHeight = true
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = true
            presentationController.detents = [
                .medium()
            ]}
    }

    private func binding() {
        cancellables.removeAll()
        
        descriptionLabel.setViewModel(vm.descriptionLabelVM)
        
        saveButton.setViewModel(
            .init(
                title: "Сохранить",
                style: .primary,
                action: .touchUpInside {[weak self] in
                    self?.vm.date = self?.datePicker.date
                    self?.vm.isBeingDismissed.toggle()
                }
            )
        )
        
        closeButton.setViewModel(
            .init(
                action: .touchUpInside {[weak self] in
                    self?.vm.isBeingDismissed.toggle()
                },
                image: UIImage(named: "back_ic")
            )
        )
        
        vm.$minimumDate.sink { [weak self] date in
            guard let date else { return }
            guard date > Date() else {
                fatalError("Min date must be larger than today")
            }
            self?.datePicker.minimumDate = date
        }
        .store(in: &cancellables)
        
        vm.$maximumDate.sink { [weak self] date in
            guard let date else { return }
            
            guard date > Date() else {
                fatalError("Max date must be larger than today")
            }

            if let minDate = self?.vm.minimumDate,
                minDate > date {
                fatalError("Max date must be larger than min date")
            }
            
            self?.datePicker.maximumDate = date
        }
        .store(in: &cancellables)
        
        vm.$date
            .sink { [weak self] date in
                guard let date else { return }
                self?.datePicker.date = date
            }
            .store(in: &cancellables)
    }
}
