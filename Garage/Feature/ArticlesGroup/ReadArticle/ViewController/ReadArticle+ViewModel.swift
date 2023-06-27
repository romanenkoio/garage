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
            titleVM.text = article.title
            textVM.text = article.text
        }
    }
}
