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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        (mainView as? UniversalSelectionView)?.selectionImage.isHidden = !selected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutMainView() {
        self.backgroundColor = .clear
        contentView.addSubview(mainView)
        let view = UIView()
        view.backgroundColor = .primaryGreen.withAlphaComponent(0.11)
        self.selectedBackgroundView = view
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
