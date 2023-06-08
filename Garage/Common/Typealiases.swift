//
//  Typealiases.swift
//  Logogo
//
//  Created by Illia Romanenko on 22.05.23.
//

import Foundation

typealias CarCell = BasicCell<CarView>
typealias SelectCell =  BasicCell<UniversalSelectionView>

typealias Completion = (() -> ())
typealias EqutableCompletion = ((any Equatable) -> ())
typealias SelectArrayCompletion = (_ items: [UniversalSelectionView.ViewModel]) -> ()
