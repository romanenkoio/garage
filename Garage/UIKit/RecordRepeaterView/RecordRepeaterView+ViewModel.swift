//
//  RecordRepeaterView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 15.08.23.
//

import Foundation
import UIKit

extension RecordRepeaterView {
    final class ViewModel: BasicViewModel {
        let labelVM = BasicLabel.ViewModel(.text("Повторить операцию"))
        let selectImageVM = BasicImageView.ViewModel(
            image: UIImage(named: "selection_ic"),
            mode: .scaleAspectFit
        )
        @Published var isSelect = false
        private(set) var interval = RepeatInterval.allCases
    }
}

extension RecordRepeaterView.ViewModel {
    enum RepeatInterval: Int, CaseIterable {
        case oneMonth = 1
        case twoMonths = 2
        case sixMonth = 6
        case year = 12
        
        var title: String {
            switch self {
                
            case .oneMonth:
                return "месяц"
            case .twoMonths:
                return "два месяца"
            case .sixMonth:
                return "6 мсеяцев "
            case .year:
                return "1 год"
            }
        }
    }
}
