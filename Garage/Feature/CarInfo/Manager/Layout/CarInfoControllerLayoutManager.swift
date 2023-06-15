//
//  CarInfoControllerLayoutManager.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//  
//

import UIKit
import SnapKit

final class CarInfoControllerLayoutManager {
    
    private unowned let vc: CarInfoViewController
    
    lazy var topStack: BasicStackView = {
        let view = BasicStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.cornerRadius = 12
        view.spacing = 10
        view.paddingInsets = .init(left: 20)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var logoImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.cornerRadius = 39
        return view
    }()
    
    lazy var recordsView: BasicView = {
       let view = BasicView()
        view.cornerRadius = 20
        view.backgroundColor = AppColors.background
        return view
    }()
    
    lazy var brandModelLabel = BasicLabel()
    lazy var yearLabel = BasicLabel()
    lazy var vinLabel = BasicLabel()
    lazy var mileageLabel = BasicLabel()
    lazy var segment = BasicSegmentView<RecordType>()
    lazy var addRecordButton = AlignedButton()
    
    
    lazy var table: BasicTableView = {
        let view = BasicTableView()
        view.setupTable(dataSource: vc, delegate: vc)
        view.register(BasicTableCell<RecordView>.self)
        view.backgroundColor = .clear
        return view
    }()
    
    // - Init
    init(vc: CarInfoViewController) {
        self.vc = vc
        configure()
        vc.disableScrollView()
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CarInfoControllerLayoutManager {
    
    private func configure() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        vc.contentView.addSubview(topStack)
        topStack.addArrangedSubviews([
            logoImage,
            brandModelLabel,
            mileageLabel,
            yearLabel,
            vinLabel
        ])
        vc.contentView.addSubview(recordsView)
        recordsView.addSubview(segment)
        recordsView.addSubview(table)
        vc.contentView.addSubview(addRecordButton)
        
        brandModelLabel.font = .custom(size: 18, weight: .black)
        yearLabel.font = .custom(size: 14, weight: .bold)
        vinLabel.font = .custom(size: 14, weight: .bold)
        mileageLabel.font = .custom(size: 14, weight: .bold)
    }
    
    private func makeConstraint() {
        logoImage.snp.makeConstraints { make in
            make.height.width.equalTo(78)
        }
        
        topStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        recordsView.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom).offset(21)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        segment.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(UIEdgeInsets.horizintal)
        }
        
        table.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segment.snp.bottom)
        }
        
        addRecordButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(bottom: 21))
        }
    }
}
