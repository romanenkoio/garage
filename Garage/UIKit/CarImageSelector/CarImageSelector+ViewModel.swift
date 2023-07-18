//
//  CarImageSelector+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 18.07.23.
//

import Foundation

extension CarImageSelector {
    final class ViewModel: BasicViewModel {
        var logoVM = BasicImageView.ViewModel()
        
        init(logoVM: BasicImageView.ViewModel) {
            self.logoVM = logoVM
        }
    }
}
