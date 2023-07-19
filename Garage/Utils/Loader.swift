
//
//  LoaderView.swift
//  PlantsFlowersRecongizer
//
//  Created by Artur Radziukhin on 1.11.22.
//
// swiftlint:disable multiline_arguments

import UIKit
import Lottie

class LoaderView: UIView {

    // - UI
    let backgroundRectangleView = UIView(frame: .init(x: 0, y: 0, width: 300, height: 300))
    let animationView = LottieAnimationView()
    let blurEffectView = UIVisualEffectView()
    
    private(set) var isFirstLoopFinished: Bool = false
    private(set) var canDismiss: Bool = false

    // - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: -
// MARK: - Interface

extension LoaderView {
    
    @objc func dismissLoader() {
        self.canDismiss = true
        dismissIfNeeded()
    }
    
    private func dismissIfNeeded() {
        if canDismiss && isFirstLoopFinished {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.blurEffectView.effect = nil
                
            } completion: { [weak self] isFinished in
                guard isFinished else { return }
                self?.removeFromSuperview()
            }
        }
    }
    
    @objc private func appDidBecomeActive() {
        startLoader(from: animationView.currentProgress)
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension LoaderView {
    
    private func configure() {
        configureLayout()
        configureLoaderLottie()
        startLoader()
        configureNotifications()
    }
    
    private func startLoader(from progress: AnimationProgressTime = 0) {
        animationView.animationSpeed = 3
        animationView.play(
            fromProgress: progress,
            toProgress: 1,
            loopMode: .playOnce
        ) { [weak self] isFinished in
            
            guard let self, isFinished else { return }
            self.isFirstLoopFinished = true
            self.dismissIfNeeded()
            self.animationView.animationSpeed = 1
            self.animationView.play(
                fromProgress: 0,
                toProgress: 1,
                loopMode: .loop
            )
        }
    }

    private func configureLayout() {
        blurEffectView.effect = nil
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        UIView.animate(withDuration: 1) { [weak self] in
            self?.blurEffectView.effect = UIBlurEffect(style: .regular)
        }
        backgroundRectangleView.backgroundColor = .clear
        self.addSubview(backgroundRectangleView)
        
        let widthHeight = CGFloat(300)
        backgroundRectangleView.frame = CGRect(
            x: (UIScreen.main.bounds.width / 2) - (widthHeight / 2) - 50,
            y: (UIScreen.main.bounds.height / 2) - (widthHeight / 2) - 20,
            width: widthHeight,
            height: widthHeight
        )
    }
    
    private func configureLoaderLottie() {
        guard let animation = LottieAnimation.named("loader.json", animationCache: DefaultAnimationCache.sharedCache)
        else { return }
        
        animationView.animation = animation
        animationView.animationSpeed = 1
        animationView.contentMode = .scaleAspectFit
        backgroundRectangleView.addSubview(animationView)
        
        let widthHeight = CGFloat(300)
        animationView.frame = CGRect(
            x: 0,
            y: 0,
            width: widthHeight,
            height: widthHeight
        )

    }
    
    private func configureNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
}
