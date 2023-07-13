//
//  DetailsView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 21.06.23.
//

import UIKit

extension DetailsView {
    final class ViewModel: BasicViewModel {
        let labelVM = BasicLabel.ViewModel(.text("Смотреть детали"))
        let image = UIImage(named: "arrow_right_ic")?.withTintColor(AppColors.blue)
        var action: Action?
        
        init(action: Action? = nil) {
            self.action = action
        }
    }
}
