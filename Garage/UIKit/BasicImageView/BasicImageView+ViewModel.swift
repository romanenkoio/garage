//
//  BasicImageView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 15.07.23.
//

import UIKit

extension BasicImageView {
    final class ViewModel: BasicViewModel {
        @Published var image: UIImage?
        @Published var mode: UIImageView.ContentMode = .scaleAspectFit
        @Published var isHidden: Bool = false
        
        init(
            image: UIImage? = nil,
            mode: UIImageView.ContentMode = .scaleAspectFit
        ) {
            self.image = image
            self.mode = mode
        }
        
        func set(from data: Data, placeholder: UIImage? = nil) {
            self.image = placeholder
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let image = UIImage(data: data) else { return }
                self?.image = image
            }
        }
        
        func set(from url: String, placeholder: UIImage? = nil) {
            if let placeholder {
                self.image = placeholder
            }
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let url = URL(string: url),
                      let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data)
                else { return }
                self?.image = image
            }
        }
    }
}
