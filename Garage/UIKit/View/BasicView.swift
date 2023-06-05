//
//  BasicView.swift
//  Logogo
//
//  Created by Illia Romanenko on 13.05.23.
//

import UIKit
import SnapKit
import Combine

class BasicView: UIView {
    var cancellables: Set<AnyCancellable> = []

    init() {
        super.init(frame: .zero)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initView()
    }
    
    func initView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 24
    }
}
