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
        vm.$image.sink { [weak self] image in
            self?.image = image
        }
        .store(in: &cancellables)
        
        vm.$mode.sink { [weak self] mode in
            self?.contentMode = mode
        }
        .store(in: &cancellables)
    }

}
