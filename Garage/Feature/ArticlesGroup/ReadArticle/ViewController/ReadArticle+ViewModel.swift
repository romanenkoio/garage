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
        
        init(article: Article) {
            titleVM.textValue = .text(article.title)
            textVM.textValue = .text(article.text)
        }
    }
}
