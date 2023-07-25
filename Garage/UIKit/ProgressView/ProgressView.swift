//
//  ProgressView.swift
//  Garage
//
//  Created by Illia Romanenko on 25.07.23.
//

import UIKit

final class ProgressView: BasicView {
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .red
        view.progressTintColor = AppColors.blue
        view.backgroundColor = UIColor(hexString: "#D6DDFF")
        return view
    }()
    
    override func initView() {
        makeLayout()
        makeConstraint()
    }
    
    private func makeLayout() {
        self.addSubview(progressView)
    }
    
    private func makeConstraint() {
        self.progressView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        vm.$progress.compactMap().sink { [weak self] value in
            self?.progressView.setProgress(Float(value), animated: true)
        }
        .store(in: &cancellables)
    }
}
