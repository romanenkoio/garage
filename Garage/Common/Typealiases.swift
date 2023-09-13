//
//  Typealiases.swift
//  Logogo
//
//  Created by Illia Romanenko on 22.05.23.
//

import Foundation

typealias CarCell = BasicTableCell<CarView>
typealias AddCarCell = BasicTableCell<AddCarView>
typealias SelectCell =  BasicTableCell<UniversalSelectionView>
typealias ServiceCell =  BasicTableCell<ServiceView>
typealias DocumentCell =  BasicTableCell<DocumentView>
typealias RecordCell = BasicTableCell<RecordView>
typealias PhotoCell = BasicCollectionCell<PhotoView>
typealias CarCellPhotoCell = BasicCollectionCell<CarCellPhotoView>
typealias BannerCell = BasicTableCell<PremiumView>
typealias StatisticCell = BasicTableCell<StatisticView>

typealias Completion = (() -> ())
typealias EqutableCompletion = ((any Equatable) -> ())
typealias SelectArrayCompletion = (_ items: [Selectable]) -> ()
typealias StatisticModel = (record: Record?, stringValue: String?, description: String)
