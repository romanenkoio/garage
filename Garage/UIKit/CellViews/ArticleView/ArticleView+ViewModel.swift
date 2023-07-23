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
        let imageVM = BasicImageView.ViewModel(data: nil)
        
        init(
            article: Article
        ) {
            self.imageVM.set(from: article.picture)
            self.titleVM.textValue = .text(article.title)
        }
    }
}
