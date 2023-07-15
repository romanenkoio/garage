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
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .primaryBlue
        switcher.addTarget(
            self,
            action: #selector(toggle(_:)),
            for: .valueChanged
        )
        switcher.isUserInteractionEnabled = true
        return switcher
    }()
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.viewModel = vm
        
        vm.stateSubject.sink { [weak self] value in
            self?.isOn = value
        }
        .store(in: &cancellables)
    }
    
    @objc private func toggle(_ sender: UISwitch) {
        self.viewModel?.changeState(isOn: sender.isOn)
    }
}
