//
//  QrServiceReader+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 15.07.23.
//  
//

import UIKit
import AVFoundation
import Combine

extension QrServiceReaderViewController {
    final class ViewModel: BasicViewModel {
        var servise: PassthroughSubject<Service, Never> = .init()
        
        override init() {
            super.init()
            
        }
        
        func found(code: String) {
            guard let data = code.data(using: .utf8),
                  let decodedService = try? JSONDecoder().decode(Service.self, from: data)
            else { return }
            self.servise.send(decodedService)
        }
    }
}
