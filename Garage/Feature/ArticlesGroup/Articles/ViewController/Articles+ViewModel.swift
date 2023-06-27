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
        let tableVM = BasicTableView.GenericViewModel<Article>()
        
        override init() {
            super.init()
            tableVM.setCells([.test, .test, .test])
        }
    }
}


