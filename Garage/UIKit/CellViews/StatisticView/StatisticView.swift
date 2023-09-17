//
//  StatisticView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 22.08.23.
//

import UIKit

class StatisticView: BasicView {
    private lazy var valueLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.edgeInsets = UIEdgeInsets(all: 20)
        stack.backgroundColor = .white
        return stack
    }()
    
    private lazy var chevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_right_ic")?.withTintColor(AppColors.blue)
        return imageView
    }()
    
    private lazy var containerView: BasicView = {
        let view = BasicView()
        view.cornerRadius = 16
        return view
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
        backgroundColor = .clear
    }
    
    override func prepareForViewReuse() {
        chevronImage.isHidden = false
    }
    
    private func makeLayout() {
        addSubview(containerView)
        containerView.addSubview(stack)
        containerView.addSubview(chevronImage)
        
        stack.addArrangedSubviews([valueLabel, descriptionLabel])
    }
    
    private func makeConstraint() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 20))
            make.top.bottom.equalToSuperview().inset(UIEdgeInsets(vertical: 6))
        }
        
        stack.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        chevronImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.centerY.trailing.equalToSuperview().inset(UIEdgeInsets(right: 24))
            make.leading.greaterThanOrEqualTo(stack.snp.trailing)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        vm.$cellValue
            .sink {[weak self] value in
                guard let self else { return }

                if let record = value.statValue.record {
                    valueLabel.setViewModel(.init(.text(record.short)))
                    descriptionLabel.setViewModel(.init(.text(value.statValue.description)))
                } else if let stringValue = value.statValue.stringValue {
                    valueLabel.setViewModel(.init(.text(stringValue)))
                    descriptionLabel.setViewModel(.init(.text(value.statValue.description)))
                }

                switch value {
                    case .averageSum, .averageSumPerYear:
                        chevronImage.isHidden = true
                    default: break
                }
            }
            .store(in: &cancellables)
    }
}
