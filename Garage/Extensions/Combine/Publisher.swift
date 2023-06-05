//
//  Publisher.swift
//  BSB-Mobile
//
//  Created by Alexey Oshevnev on 20.01.2023.
//

import Foundation
import Combine

extension Publisher {
    func compactMap<T>() -> Publishers.CompactMap<Self, T> where Output == T? {
        compactMap { $0 }
    }

    func scanPrevious() -> AnyPublisher<(previous: Output?, current: Output), Failure> {
        scan(Optional<(Output?, Output)>.none, { ($0?.1, $1) })
            .compactMap()
            .eraseToAnyPublisher()
    }
}

extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<T, Output>,
        on target: T
    ) -> AnyCancellable {
        sink { [weak target] in target?[keyPath: keyPath] = $0 }
    }
}
