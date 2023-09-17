//
//  PremiumView.swift
//  Garage
//
//  Created by Illia Romanenko on 25.07.23.
//

import UIKit

final class PremiumView: BasicCellView {
    
    lazy var gradientView = GradientView(
        startColor: UIColor(hexString: "#9E00E8"),
        endColor: UIColor(hexString: "#0094FF"),
        horizontalMode: true
    )
    
    private lazy var textStack: BasicStackView = {
       let stack = BasicStackView()
        stack.axis = .vertical
        stack.backgroundColor = .clear
        stack.spacing = 7
        return stack
    }()
    
    private lazy var mainTextLabel: BasicLabel = {
        let label = BasicLabel(font: .custom(size: 18, weight: .extrabold))
        label.textColor = .white
        return label
    }()
    
    private lazy var subTextLabel: BasicLabel = {
        let label = BasicLabel(font: .custom(size: 12, weight: .semibold))
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private var arrowImage = BasicImageView(image: UIImage(named: "premium_arrow_ic"), mode: .scaleAspectFit)
    var insets: UIEdgeInsets = .init(all: 0) {
        didSet {
            gradientView.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(insets)
            }
        }
    }
    
    override func initView() {
        makeLayout()
        makeConstraint()
        setupGestures()
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPrem))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func openPrem() {
        TabBarController.sh.showPremium()
    }
    
    private func makeLayout() {
        self.addSubview(gradientView)
        gradientView.addSubview(textStack)
        gradientView.addSubview(arrowImage)
        textStack.addArrangedSubviews([mainTextLabel, subTextLabel])
    }
    
    private func makeConstraint() {
        self.snp.makeConstraints { make in
            make.height.equalTo(93)
        }
        
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(insets)
        }
        
        textStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(arrowImage.snp.leading).offset(-40)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(11)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.mainTextLabel.setViewModel(vm.mainLabelVM)
        self.subTextLabel.setViewModel(vm.subTextLabelVM)
    }
}
