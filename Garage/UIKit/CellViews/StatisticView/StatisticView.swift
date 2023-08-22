//
//  StatisticView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 22.08.23.
//

import UIKit

class StatisticView: BasicView {
    private lazy var headerLabel: BasicLabel = {
        let label = BasicLabel(font: .custom(size: 18, weight: .bold))
        label.textColor = AppColors.subtitle
        label.textInsets = .init(all: 16)
        return label
    }()
    
    private lazy var VStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
        backgroundColor = .clear
    }
    
    private func makeLayout() {
        addSubview(headerLabel)
        addSubview(VStack)
    }
    
    private func makeConstraint() {
        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        VStack.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        VStack.clearArrangedSubviews()
        vm.$cellValue
            .sink {[weak self] value in
                guard let self else { return }
                switch value {
                    case .averageSumPerYear:
                        headerLabel.setViewModel(.init(.text(value.header)))
                        
                        guard let sortedByYear = value.valueSum?.sorted(by: {$0.0 ?? 0 > $1.0 ?? 0}) else { return }
                        
                        sortedByYear.forEach({ year,value in
                            let stack = BasicStackView()
                            stack.edgeInsets = UIEdgeInsets(vertical: 8, horizontal: 20)
                            
                            let yearLabel = BasicLabel(font: .custom(size: 14, weight: .bold))
                            yearLabel.textColor = AppColors.black.withAlphaComponent(0.7)
                            yearLabel.textInsets = UIEdgeInsets(horizontal: 16)
                            
                            let valueLabel = BasicLabel(font: .custom(size: 16, weight: .bold))
                            valueLabel.textColor = AppColors.black.withAlphaComponent(0.7)
                            valueLabel.backgroundColor = .white
                            valueLabel.cornerRadius = 16
                            valueLabel.textInsets = UIEdgeInsets(vertical: 25,horizontal: 16)
                            
                            if let year {
                                yearLabel.setViewModel(.init(.text("\(year)")))
                                self.VStack.addArrangedSubviews([yearLabel])
                            }
                            
                            stack.addArrangedSubviews([valueLabel])
                            valueLabel.setViewModel(.init(.text("\(value) BYN")))
                            self.VStack.addArrangedSubviews([stack])
                        })
                        
                    case .mostFrequentOperation:
                        headerLabel.setViewModel(.init(.text(value.header)))
                        
                        value.valueOperation?.forEach({ year,value in
                            let stack = BasicStackView()
                            stack.edgeInsets = UIEdgeInsets(vertical: 8, horizontal: 20)
                            
                            let valueLabel = BasicLabel(font: .custom(size: 16, weight: .bold))
                            valueLabel.textColor = AppColors.black.withAlphaComponent(0.7)
                            valueLabel.backgroundColor = .white
                            valueLabel.cornerRadius = 16
                            valueLabel.textInsets = UIEdgeInsets(vertical: 25,horizontal: 16)
                            
                            stack.addArrangedSubviews([valueLabel])
                            valueLabel.setViewModel(.init(.text("\(value)")))
                            self.VStack.addArrangedSubviews([stack])
                        })
                        
                    default:
                        headerLabel.setViewModel(.init(.text(value.header)))
                        let sortedByYear = value.record?.sorted(by: {$0.0 ?? 0 > $1.0 ?? 0})
                        
                        sortedByYear?.forEach({ year,value in
                            
                            let cellView = RecordView()
                            let yearLabel = BasicLabel(font: .custom(size: 14, weight: .bold))
                            yearLabel.textColor = AppColors.black.withAlphaComponent(0.7)
                            yearLabel.textInsets = UIEdgeInsets(horizontal: 16)
                            
                            if let year {
                                yearLabel.setViewModel(.init(.text("\(year)")))
                                self.VStack.addArrangedSubviews([yearLabel])
                            }
                            
                            if let value {
                                cellView.setViewModel(.init(record: value))
                                self.VStack.addArrangedSubviews([cellView])
                            }
                        })
                        
                }
            }
            .store(in: &cancellables)
    }
}
