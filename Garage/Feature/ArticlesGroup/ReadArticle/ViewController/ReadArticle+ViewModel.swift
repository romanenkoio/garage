//
//  ReadArticle+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 28.06.23.
//  
//

import UIKit

extension ReadArticleViewController {
    final class ViewModel: BasicViewModel {
        let titleVM = BasicLabel.ViewModel()
        let textVM = BasicLabel.ViewModel()
        let imageVM = BasicImageView.ViewModel(data: nil, mode: .scaleAspectFill)
        
        init(article: Article) {
            titleVM.textValue = .text(article.title)
            textVM.textValue = .text(article.text)
            imageVM.set(from: "https://pictures.shoop-vooop.cloudns.nz/shopping-list/api/news/images/\(article.id)/")
        }
    }
}
