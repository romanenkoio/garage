//
//  BasicTableView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//

import UIKit

extension BasicTableView {
    final class ViewModel: BasicViewModel {
  
        private(set) var labelVM = BasicLabel.ViewModel()

        @Published
        private(set) var cells = [UIView]()
        @Published
        private(set) var image: UIImage?
        
        func setCells(_ cells: [UIView]) {
            self.cells = cells
        }
        
        func setupEmptyState(
            labelVM: BasicLabel.ViewModel,
            image: UIImage?
        ) {
            self.labelVM = labelVM
            self.image = image
        }
    }
}
