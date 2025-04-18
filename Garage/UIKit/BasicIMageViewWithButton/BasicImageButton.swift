//
//  BasicImageView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 10.06.23.
//

import UIKit
import Combine


class BasicImageButton: BasicView {
    enum ImageViewStyle {
        case photo
        case empty
    }
    
    private lazy var actionButton = BasicButton()
    private lazy var actionImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
   
    private(set) var viewModel: ViewModel?
    
    override init() {
        super.init()
        cornerRadius = 8
        actionImageView.cornerRadius = 8
        makeLayout()
        makeConstraints()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(actionImageView)
        addSubview(actionButton)
    }
    
    private func makeConstraints() {
        actionImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 4))
            make.top.bottom.equalToSuperview().inset(UIEdgeInsets(vertical: 4))
            make.height.width.equalTo(actionImageView.snp.width)
        }
    }
    
    private func makeButtonConstraints(style: ButtonStyle) {
        switch style {
            case .addImage:
                actionButton.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                    make.height.width.equalTo(actionImageView.snp.width)
                }
                actionButton.cornerRadius = 8
            case .removeImage:
                actionButton.snp.remakeConstraints { make in
                    make.trailing.top.equalToSuperview()
                    make.height.width.equalTo(20)
                }
            default:
                break
        }
    }
    
    private func setStyle(with style: ImageViewStyle) {
        switch style {
            case .empty:
                layer.borderWidth = 0
                layer.borderColor = UIColor.clear.cgColor
            case .photo:
                layer.borderWidth = 0
                layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.viewModel = vm
        if let buttonVM = vm.buttonVM {
            actionButton.setViewModel(buttonVM)
        }
        
        vm.$buttonStyle.sink {[weak self] style in
            if let style {
                self?.makeButtonConstraints(style: style)
            }
        }
            .store(in: &cancellables)
        
        vm.$action.sink { [weak self] _ in
            guard let self else { return }
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(self.tapAction)
            )
            tap.delegate = self
            self.actionImageView.addGestureRecognizer(tap)
        }
        .store(in: &cancellables)
        
        vm.$image.sink {[weak self] image in
            guard let self else { return }
            self.actionImageView.image = image
        }
        .store(in: &cancellables)
        
        vm.$style
            .sink { [weak self] in self?.setStyle(with: $0)}
            .store(in: &cancellables)
    }
    
    @objc private func tapAction() {
        if let action = viewModel?.action {
            action()
        }
    }
}

extension BasicImageButton: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        gestureRecognizer.cancelsTouchesInView = false
        return true
    }
}
