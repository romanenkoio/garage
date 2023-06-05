//
//  UIControl+Extension.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 18.05.23.
//

import Combine
import UIKit

extension UIControl {
    final class InteractionSubscription<
        SubscriberType: Subscriber,
        Control: UIControl
    >: Subscription where SubscriberType.Input == Control {
        private var subscriber: SubscriberType?
        private let control: Control

        init(
            subscriber: SubscriberType,
            control: Control,
            event: UIControl.Event
        ) {

            self.subscriber = subscriber
            self.control = control

            self.control.addTarget(self, action: #selector(handleEvent), for: event)
        }

        @objc
        private func handleEvent(_ sender: UIControl) {
            _ = self.subscriber?.receive(self.control)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            self.subscriber = nil
        }
    }

    struct InteractionPublisher<Control: UIControl>: Publisher {
        typealias Output = Control
        typealias Failure = Never

        private let control: Control
        private let events: UIControl.Event

        init(control: Control, events: UIControl.Event) {
            self.control = control
            self.events = events
        }

        func receive<S: Subscriber>(subscriber: S) where S.Failure == Self.Failure,
                                                         S.Input == Self.Output {
            let subscription = InteractionSubscription(
                subscriber: subscriber,
                control: control,
                event: events
            )

            subscriber.receive(subscription: subscription)
        }
    }

    func publisher(for events: UIControl.Event) -> InteractionPublisher<UIControl> {
        return InteractionPublisher(control: self, events: events)
    }
}

