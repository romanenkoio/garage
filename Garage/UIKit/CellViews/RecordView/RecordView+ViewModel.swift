//
//  RecordView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import Foundation

extension RecordView {
    final class ViewModel: BasicViewModel {
        private(set) var record: Record
        
        init(record: Record) {
            self.record = record
        }
    }
}
