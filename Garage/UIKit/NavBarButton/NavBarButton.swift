//
//  NavBarButton.swift
//  Garage
//
//  Created by Illia Romanenko on 8.06.23.
//

import UIKit
import Combine

class NavBarButton: UIButton {
    var cancellables: Set<AnyCancellable> = []

    private var actionCancellable: AnyCancellable? {
            didSet { oldValue?.cancel() }
    }
    
    init() {
        super .init(frame: .zero)
        tintColor = .primaryBlue
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        vm.$action
            .sink { [weak self] action in
                guard let self else { return }
                self.actionCancellable = nil
                guard let action else { return }
                self.actionCancellable = self.publisher(for: action.event).sink(receiveValue: { _ in action() })
            }
            .store(in: &cancellables)
        
        vm.$image.sink { [weak self] image in
            self?.setImage(image, for: .normal)
        }
        .store(in: &cancellables)
    }
}
