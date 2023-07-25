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
        let upButtonVM = ActionImage.ViewModel(image: UIImage(named: "up_button_ic"))
        
        let arcticle: Article!
        
        init(article: Article) {
            self.arcticle = article
            titleVM.textValue = .text(article.title)
            textVM.textValue = .text(article.text)
            imageVM.set(from: "https://pictures.shoop-vooop.cloudns.nz/shopping-list/api/news/images/\(article.id)/")
        }
        
        func markAsRead() {
            var readed: [Int] = SettingsManager.sh.read(.readedArticles)
            if !readed.contains(where: { $0 == arcticle.id }) {
                readed.append(arcticle.id)
                SettingsManager.sh.write(value: readed, for: .readedArticles)
            }
        }
    }
}
