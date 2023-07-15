//
//  BasicSwitch.swift
//  Logogo
//
//  Created by Illia Romanenko on 3.06.23.
//



import UIKit
import Combine

class BasicSwitch: UISwitch {
    var cancellables: Set<AnyCancellable> = []

    private(set) var viewModel: ViewModel?
    
    init() {
        super.init(frame: .zero)
        self.onTintColor = AppColors.blue
        self.addTarget(
            self,
            action: #selector(toggle(_:)),
            for: .valueChanged
        )
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.viewModel = vm
        
        vm.$isOn.sink { [weak self] value in
            self?.isOn = value
        }
        .store(in: &cancellables)
    }
    
    @objc private func toggle(_ sender: UISwitch) {
        self.viewModel?.changeState(isOn: sender.isOn)
    }
}
