//
//  GradientView.swift
//  Garage
//
//  Created by Illia Romanenko on 20.07.23.
//

import UIKit

class GradientView: BasicView {
    var startColor:   UIColor = UIColor(hexString: "#9E00E8") { didSet { updateColors() }}
    var endColor:     UIColor = UIColor(hexString: "#0094FF") { didSet { updateColors() }}
    var startLocation: Double =  0                            { didSet { updateLocations() }}
    var endLocation:   Double =  1                            { didSet { updateLocations() }}
    var horizontalMode:  Bool =  false                        { didSet { updatePoints() }}
    var diagonalMode:    Bool =  false                        { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    init(
        startColor: UIColor = .black,
        endColor: UIColor = .white,
        startLocation: Double = 0,
        endLocation: Double = 1,
        horizontalMode: Bool = false,
        diagonalMode: Bool = false
    ) {
        self.startColor = startColor
        self.endColor = endColor
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.horizontalMode = horizontalMode
        self.diagonalMode = diagonalMode
        super.init()
    }
    
    override func initView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.layer.cornerRadius = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    
    private func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
}
