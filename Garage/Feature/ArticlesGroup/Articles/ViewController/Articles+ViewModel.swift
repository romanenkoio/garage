//
//  Articles+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 27.06.23.
//  
//

import UIKit

extension ArticlesViewController {
    final class ViewModel: BasicViewModel {
        let tableVM = BasicTableView.GenericViewModel<ArticleView.ViewModel>()
        let articles: [News] = .empty
        
        override init() {
            super.init()
        }
        
        func readArticles() {
            Task { @MainActor in
                do {
                    let result = try await NetworkManager
                        .sh
                        .request(
                            GarageApi.news,
                            model: News.self
                        ).results
                    tableVM.setCells(result.map({ .init(article: $0)}))
                } catch let error {
                    print(error)
                }
            }
        }
    }
}


