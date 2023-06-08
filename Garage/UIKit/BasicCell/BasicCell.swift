//
//  BasicCell.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 19.05.23.
//

import UIKit

final class BasicCell<T: UIView>: UITableViewCell {
    var mainView = T()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutMainView() {
//        selectionStyle = .none
        self.backgroundColor = .clear
        contentView.addSubview(mainView)
        selectionStyle = .none
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
