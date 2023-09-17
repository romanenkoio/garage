//
//  BasicCellView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 17.09.23.
//

import UIKit

class BasicCellView: BasicView {
    
//    override init() {
//        super.init()
//    }
    
    required override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {}
}
