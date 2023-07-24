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
        
        let article: Article!
        
        init(
            article: Article
        ) {
            self.article = article
            self.imageVM.set(from: "https://pictures.shoop-vooop.cloudns.nz/shopping-list/api/news/images/\(article.id)/")
            self.titleVM.textValue = .text(article.title)
        }
    }
}
