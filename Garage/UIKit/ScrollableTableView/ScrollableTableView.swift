//
//  ScrollableTableView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 23.06.23.
//

import UIKit

class ScrollableTableView: UITableView {
    
    init(style: UITableView.Style = .plain) {
        super.init(frame: .zero, style: style)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = true
        backgroundColor = .clear
        bounces = true
        alwaysBounceVertical = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTable(
        dataSource: UITableViewDataSource,
        delegate: UITableViewDelegate? = nil
    ) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        self.register(type)
    }
    
    func reload() {
        reloadData()
    }
    
}
