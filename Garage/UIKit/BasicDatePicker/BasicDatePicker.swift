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
        rightView?.isUserInteractionEnabled = false
        rightViewMode = .always
    }
    
    private func makeConstraints() {
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(all: .zero))
        }
    }
    
    func setViewModel(_ vm: BasicDatePicker.ViewModel) {
        self.viewModel = vm
        vm.$date
            .sink { [weak self] value in
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
        
        vm.$text.dropFirst().sink { [weak self] text in
            self?.text = text
        }
        .store(in: &cancellables)
    
        vm.datePickerController.$isBeingDismissed
            .dropFirst()
            .sink {[weak self] _ in
                guard let self else { return }
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                
                sceneDelegate?.window?.rootViewController?.dismiss(
                    animated: true,
                    completion: {
                        _ = self.resignFirstResponder()
                    }
                )
            }
            .store(in: &cancellables)
    }

    @objc private func presentPicker() {
        _ = super.becomeFirstResponder()
        let datePickerController = DatePickerController(vm: viewModel!.datePickerController)
        TabBarController.sh.present(datePickerController, animated: true)
    }
}
