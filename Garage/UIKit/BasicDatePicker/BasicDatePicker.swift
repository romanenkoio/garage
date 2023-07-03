//
//  BasicDatePicker.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 31.05.23.
//

import UIKit
import SnapKit

class BasicDatePicker: BasicTextField {
    private(set) var viewModel: ViewModel?
    
    lazy var emptyView: BasicView = {
        let view = BasicView()
        view.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        view.addGestureRecognizer(tap)
        return view
    }()

    lazy private var alertController: UIAlertController = {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) {[weak self] _ in
            guard let self else { return }
            _ = self.resignFirstResponder()
        }
        cancelAction.setValue(UIColor.primaryBlue, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        return alert
    }()
    
    lazy private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.addTarget(self, action: #selector(pickerAction(sender:)), for: .valueChanged)
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        picker.tintColor = .primaryBlue
        picker.locale = Locale(identifier: "ru_BY")
        return picker
    }()
    
    lazy private var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .gray
        imageView.frame = CGRect(
            x: self.frame.size.width,
            y: 5,
            width: 25,
            height: 25
        )
        return imageView
    }()
    
    override init() {
        super.init()
        makeLayout()
        makeConstraints()
        tintColor = .clear
        inputView = UIView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(descriptionLabel)
        alertController.view.addSubview(datePicker)
        addSubview(emptyView)
        rightView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 35,
                height: 35
            )
        )
        rightView?.addSubview(rightImageView)
        rightViewMode = .always
    }
    
    private func makeConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(all: .zero))
        }

        datePicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(60)
//            make.top.equalTo(descriptionLabel.snp.bottom)
            make.top.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: BasicDatePicker.ViewModel) {
        self.viewModel = vm
        
        vm.$date.sink { [weak self] value in
                guard let self else { return }
                self.text = value?.toString(.ddMMyy) ?? .empty
            }
            .store(in: &cancellables)

        vm.$placeholder
            .sink { [weak self] value in
                guard let value,
                      let self else { return }
                self.attributedPlaceholder = value.attributedString(
                    font: .custom(size: 17, weight: .medium),
                    textColor: self.isEnabled ? .textGray : .textLightGray.withAlphaComponent(0.2)
                )
            }
            .store(in: &cancellables)
        
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

            if let minDate = vm.minimumDate, minDate > date {
                fatalError("Max date must be larger than min date")
            }
            
            self?.datePicker.maximumDate = date
        }
        .store(in: &cancellables)
        
        vm.$text.dropFirst().sink { [weak self] text in
            self?.text = text
        }
        .store(in: &cancellables)
    }
    
    @objc private func presentPicker() {
        _ = super.becomeFirstResponder()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    @objc private func pickerAction(sender: UIDatePicker) {
        self.viewModel?.setNewDate(sender.date)
    }
}
