//
//  BasicImageView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 10.06.23.
//

import UIKit
import Combine


class BasicImageViewWithButton: UIImageView {
    var cancellables: Set<AnyCancellable> = []
    lazy var actionButton = BasicButton()
    private(set) var viewModel: ViewModel?
    private(set) var buttonStyle: ButtonStyle?
    
    init() {
        super.init(frame: .zero)
        snp.makeConstraints { make in
            make.height.width.equalTo(55)
        }
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        cornerRadius = 8
        backgroundColor = .primaryGray
        contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(actionButton)
    }
    
    private func makeConstraints() {
        switch buttonStyle {
            case .addImage:
                actionButton.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                    make.height.width.equalTo(35)
                }
            case .removeImage:
                actionButton.snp.remakeConstraints { make in
                    make.trailing.top.equalToSuperview()
                    make.height.width.equalTo(20)
                }
            default:
                break
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        actionButton.setViewModel(vm.buttonVM)
        
        vm.$image.sink {[weak self] image in
            guard let self else { return }
            self.image = image
        }
        .store(in: &cancellables)
        
        vm.$buttonStyle.sink {[weak self] style in
            self?.buttonStyle = style
            self?.makeConstraints()
        }
            .store(in: &cancellables)
    }
    
    @objc func testAction() {
        print("testAction")
    }
}
