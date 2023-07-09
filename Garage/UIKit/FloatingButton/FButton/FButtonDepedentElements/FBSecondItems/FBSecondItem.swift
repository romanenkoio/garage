//
//  FBSecondItem.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.07.23.
//

import UIKit

class FloatingButtonSecondItem: BasicView {
    var secondItemTappableLabel: TappableLabel = {
        let label = TappableLabel()
        label.numberOfLines = 0
        label.font = .custom(size: 18, weight: .semibold)
        label.textColor = .white
        label.textInsets = UIEdgeInsets(left: 48)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    
    var secondItemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.tintColor = .white
        return view
    }()
    
    override init() {
        super.init()
        makeLayout()
        makeConstraints()
        backgroundColor = ColorScheme.current.buttonColor
        cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(secondItemImageView)
        addSubview(secondItemTappableLabel)
    }
    
    private func makeConstraints() {
        self.snp.makeConstraints { make in
            make.width.equalTo(220)
        }
        
        secondItemTappableLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        secondItemImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.leading.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 21, bottom: 21, left: 20))
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        vm.$image.sink { [weak self]  in self?.secondItemImageView.image = $0 }
        .store(in: &cancellables)
        
        secondItemTappableLabel.setViewModel(vm.tappableLabelVM)
    }
}
