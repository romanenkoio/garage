//
//  BasicSwitch+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 3.06.23.
//

import Combine
import Foundation
import UIKit

extension BasicSwitch {
    class ViewModel {
        var titleVM: BasicLabel.ViewModel
    
        @Published var state: Bool
        @Published var image: UIImage?
        
        init(
            state: Bool,
            titleVM: BasicLabel.ViewModel,
            image: UIImage? = UIImage(systemName: "repeat")
        ) {
            self.state = state
            self.titleVM = titleVM
            self.image = image
        }
        
        func changeState(isOn: Bool) {
            self.state = isOn
        }
    }
}
