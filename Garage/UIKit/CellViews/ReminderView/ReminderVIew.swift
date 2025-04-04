//
//  ReminderVIew.swift
//  Garage
//
//  Created by Illia Romanenko on 9.07.23.
//

import UIKit

class ReminderView: BasicView {
    
    private lazy var container: BasicView = {
        let view = BasicView()
        view.backgroundColor = .white
        view.cornerRadius = 16
        return view
    }()
    
    private lazy var textStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.edgeInsets = UIEdgeInsets(all: 20)
        stack.backgroundColor = .white
        return stack
    }()
    
    private lazy var moreView: BasicView = {
        let view = BasicView()
        return view
    }()
    
    private lazy var moreImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "more_ic")
        return imageView
    }()
    
    private lazy var infoLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var dateLabel: BasicLabel = {
        let label = BasicLabel()
        label.font = .custom(size: 14, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var completeButton = BasicButton()
    
    private(set) var vm: ViewModel?

    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        addSubview(container)
        
        container.addSubview(textStack)
        textStack.addArrangedSubviews([infoLabel, dateLabel])
        container.addSubview(moreImage)
        container.addSubview(completeButton)
    }
    
    private func makeConstraint() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(vertical: 6, horizontal: 20))
        }
        
        textStack.snp.makeConstraints { make in
            make.leading.bottom.top.equalToSuperview()
            make.trailing.equalTo(completeButton.snp.leading).offset(-8)
        }
        
        moreImage.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview().inset(UIEdgeInsets(right: 20))
            make.width.height.equalTo(28)
        }
        
        completeButton.snp.makeConstraints { make in
            make.trailing.equalTo(moreImage.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.width.equalTo(81)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.vm = vm
        
        infoLabel.setViewModel(vm.infoLabelVM)
        dateLabel.setViewModel(vm.dateLabelVM)
        completeButton.setViewModel(vm.completeButton)
        
        guard let days = vm.reminder.isOverdue.days else { return }
        
        switch days {
        case _ where days <= 7:
            self.dateLabel.textColor = AppColors.error
            dateLabel.attributedText = vm.dateLabelVM.textValue.clearText.insertImage(UIImage(named: "error_ic"))

        case 7...14:
            self.dateLabel.textColor = AppColors.warning
            dateLabel.attributedText = vm.dateLabelVM.textValue.clearText.insertImage(UIImage(named: "warning_ic"))
            
        default:
            self.dateLabel.textColor = AppColors.subtitle
        }
    }
}
