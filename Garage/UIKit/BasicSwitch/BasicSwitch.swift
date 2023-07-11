//
//  BasicSwitch.swift
//  Logogo
//
//  Created by Illia Romanenko on 3.06.23.
//



import UIKit
import Combine

class BasicSwitch: BasicView {
    private(set) var viewModel: ViewModel?
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .primaryBlue
        switcher.addTarget(
            self,
            action: #selector(toggle(_:)),
            for: .valueChanged
        )
//        switcher.transform = .init(scaleX: 0.7, y: 0.7)
        switcher.isUserInteractionEnabled = true
        return switcher
    }()
    
    private lazy var label: BasicLabel = {
        let label = BasicLabel()
        label.textInsets = .init(left: 8)
        label.numberOfLines = 2
        label.font = .custom(size: 15, weight: .semibold)
        return label
    }()
    
    private lazy var leftImage: UIImageView = {
        let view = UIImageView()
        view.tintColor = .primaryBlue
        return view
    }()
    
    private lazy var stack: BasicStackView = {
        let view = BasicStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.backgroundColor = .primaryGray
        view.cornerRadius = 8
        view.edgeInsets = .init(horizontal: 16)
        view.paddingInsets = .init(horizontal: 5)
        return view
    }()
    
    override func initView() {
        makeLayout()
        makeConstraints()
    }
    
    private func makeLayout() {
        self.addSubview(stack)

        stack.addArrangedSubviews([
            leftImage,
            label,
            switcher
        ])
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        leftImage.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.viewModel = vm
        self.label.setViewModel(vm.titleVM)
        
        vm.$image.sink { [weak self] image in
            self?.leftImage.image = image
            self?.leftImage.isHidden = image == nil
        }
        .store(in: &cancellables)
    }
    
    @objc private func toggle(_ sender: UISwitch) {
        self.viewModel?.changeState(isOn: sender.isOn)
    }
}
