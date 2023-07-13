//
//  ArticleView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 27.06.23.
//

import UIKit

extension ArticleView {
    final class ViewModel: BasicViewModel {
        let titleVM = BasicLabel.ViewModel()
        @Published var image: UIImage?
        
        init(
            title: TextValue,
            image: UIImage?
        ) {
            self.image = image
            self.titleVM.textValue = title
        }
    }
}
