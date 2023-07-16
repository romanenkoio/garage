//
//  Loader.swift
//  Garage
//
//  Created by Illia Romanenko on 16.07.23.
//

import UIKit

extension UIViewController {
    func showLoader() {
        let blurLoader = BlurLoader(frame: self.view.frame)
        self.view.addSubview(blurLoader)
    }

    func removeLoader() {
        if let blurLoader = self.view.subviews.first(where: { $0 is BlurLoader }) {
            blurLoader.removeFromSuperview()
        }
    }
}


class BlurLoader: UIView {

    var blurEffectView: UIVisualEffectView?

    override init(frame: CGRect) {
        let blurEffectView = UIVisualEffectView(effect: nil)
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        super.init(frame: frame)
        addSubview(blurEffectView)
        addLoader()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLoader() {
        guard let blurEffectView = blurEffectView else { return }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = AppColors.blue
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.startAnimating()
    }
}
