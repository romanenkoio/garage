//
//  Action.swift
//  Garage
//
//  Created by Illia Romanenko on 8.06.23.
//

import UIKit

struct Action {
    typealias Completion = () -> Void

    let event: UIControl.Event
    let completion: Completion

    static func touchUpInside(completion: @escaping Completion) -> Action {
        .init(event: .touchUpInside, completion: completion)
    }

    func callAsFunction() {
        completion()
    }
}
