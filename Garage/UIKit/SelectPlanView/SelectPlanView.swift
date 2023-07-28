//
//  SelectPlanView.swift
//  Garage
//
//  Created by Illia Romanenko on 28.07.23.
//

import UIKit

class SelectPlanView: BasicView {
    
    private lazy var gradientView = GradientView()

    private lazy var periodLabel: BasicLabel = {
        let label = BasicLabel()
        label.textAlignment = .center
        label.textColor = AppColors.blue
        return label
    }()
    
    private lazy var priceLabel: BasicLabel = {
        let label = BasicLabel()
        label.textColor = .black
        label.font = .custom(size: 13, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textInsets = UIEdgeInsets(left: 10, right: 10)
        return label
    }()
    
    private lazy var cancelLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 10, weight: .semibold)
        label.textColor = UIColor(hexString: "#858585")
        label.textAlignment = .center
        label.textInsets = UIEdgeInsets(bottom: 12, left: 10, right: 10)
        return label
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(gradientView)
        self.addSubview(periodLabel)
        self.addSubview(priceLabel)
        self.addSubview(cancelLabel)
    }
    
    private func makeConstraint() {
        gradientView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(34)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.edges.equalTo(gradientView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        cancelLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        
    }
}
