//
//  UniversalSelectionView.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit

final class UniversalSelectionView: BasicCellView {
    
    private lazy var titleLabel: BasicLabel = {
        let label = BasicLabel()
        label.textInsets = .init(vertical: 15, left: 20, right: 10)
        return label
    }()
    
    lazy var selectionImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "selection_ic")
        return view
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(titleLabel)
        self.addSubview(selectionImage)
    }
    
    private func makeConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        selectionImage.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.height.width.equalTo(22)
            make.centerY.trailing.equalToSuperview().inset(UIEdgeInsets(right: 20))
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        titleLabel.setViewModel(vm.labelVM)
    }
}
