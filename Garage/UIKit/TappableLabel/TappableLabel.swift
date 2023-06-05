//
//  TappableLabel.swift
//  Logogo
//
//  Created by Illia Romanenko on 22.05.23.
//

import Foundation
import UIKit

class TappableLabel: BasicLabel {
    private(set) var vm: ViewModel?
    
    init(aligment: NSTextAlignment = .center) {
        super.init()
        self.isUserInteractionEnabled = true
        self.textAlignment = aligment
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAction() {
        self.vm?.action?()
    }
    
    func setViewModel(_ vm: TappableLabel.ViewModel) {
        self.vm = vm
        setViewModel(.init(text: vm.text))
    }
}
