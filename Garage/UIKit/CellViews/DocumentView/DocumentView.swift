//
//  DocumentView.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import Foundation
import UIKit

class DocumentView: BasicView {
    private lazy var mainView: BasicView = {
        let stack = BasicView()
//        stack.axis = .vertical
        stack.backgroundColor = AppColors.background
        stack.cornerRadius = 20
//        stack.edgeInsets = .init(top: 20, horizontal: 20)
        return stack
    }()
    
    private lazy var textStack: BasicStackView = {
       let stack = BasicStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.paddingInsets = .init(top: 20, bottom: 20, left: 16, right: 10)
        return stack
    }()

    private lazy var attachImage = BasicImageView()
    private lazy var moreImage = BasicImageView()
    
    private lazy var typeLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 16, weight: .black)
        label.textInsets = .init(bottom: 8)
        return label
    }()
    
    private lazy var dateLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 12, weight: .semibold)
        label.textColor = AppColors.subtitle
        return label
    }()

    private(set) var vm: ViewModel?

    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        addSubview(mainView)
        mainView.addSubview(textStack)
        mainView.addSubview(attachImage)
        mainView.addSubview(moreImage)
        textStack.addArrangedSubviews([typeLabel, dateLabel])
    }
    
    private func makeConstraint() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, horizontal: 20))
        }

        textStack.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }

        attachImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(18)
            make.leading.equalTo(textStack.snp.trailing)
            make.trailing.equalTo(moreImage.snp.leading).offset(-9)
        }
        
        moreImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
            make.trailing.equalToSuperview().offset(-30)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()
        self.vm = vm
        
        typeLabel.setViewModel(vm.typeLabelVM)
        dateLabel.setViewModel(vm.dateLabelVM)
        attachImage.setViewModel(vm.attachImageVM)
        moreImage.setViewModel(vm.moreImageVM)
        
        vm.$shouldShowAttention.sink { [weak self] value in
            guard let self,
                  let days = self.vm?.document.days
            else { return }
            
            switch days {
            case 0...15:
                self.dateLabel.textColor = AppColors.warning
                dateLabel.attributedText = vm.dateLabelVM.textValue.clearText.insertImage(UIImage(named: "warning_ic"))
            case _ where days <= 0:
                self.dateLabel.textColor = AppColors.error
                dateLabel.attributedText = vm.dateLabelVM.textValue.clearText.insertImage(UIImage(named: "error_ic"))
            default:
                self.dateLabel.textColor = AppColors.subtitle
            }
        }
        .store(in: &cancellables)
        
    }
}
