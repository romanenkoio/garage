//
//  BasicCell.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 19.05.23.
//

import UIKit

final class BasicTableCell<T: UIView>: UITableViewCell {
    var mainView = T()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutMainView() {
        self.backgroundColor = .clear
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

final class BasicCollectionCell<T: UIView>: UICollectionViewCell {
    var mainView = T()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutMainView()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        self.addGestureRecognizer(pinch)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutMainView() {
        self.backgroundColor = .clear
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func pinch(sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else {
            sender.view?.transform = CGAffineTransform(scaleX: 1, y: 1)
            return
        }
        sender.view?.transform = scale
       // sender.view?.layoutIfNeeded()
        sender.scale = 1
    }
}
