//
//  BasicImageView.swift
//  Garage
//
//  Created by Illia Romanenko on 15.07.23.
//

import UIKit
import Combine

class BasicImageView: UIImageView {
    var cancellables: Set<AnyCancellable> = []
    
    init(
        image: UIImage? = nil,
        mode: UIImageView.ContentMode = .scaleAspectFit
    ) {
        super.init(frame: .zero)
        self.image = image
        self.layer.masksToBounds = true
        self.contentMode = mode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setViewModel(_ vm: ViewModel) {
        vm.$image
            .receive(on: DispatchQueue.main)
            .compactMap()
            .sink { [weak self] in self?.image = $0 }
            .store(in: &cancellables)
        
        vm.$mode
            .sink { [weak self] in self?.contentMode = $0 }
            .store(in: &cancellables)
        
        vm.$isHidden
            .sink { [weak self] in self?.isHidden = $0 }
            .store(in: &cancellables)
    }

}
