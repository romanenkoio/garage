//
//  ProgressView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 25.07.23.
//

import Foundation

extension ProgressView {
    final class ViewModel: BasicViewModel {
        @Published var progress: CGFloat?
    }
}
