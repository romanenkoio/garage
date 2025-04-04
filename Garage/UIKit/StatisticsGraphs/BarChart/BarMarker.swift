//
//  BarMarker.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 29.07.23.
//

import DGCharts
import UIKit

enum ChartType {
    case pie
    case bar
}

class CustomMarkerView: MarkerView {
    private var chartType = ChartType.bar
    
    private lazy var label: BasicLabel = {
        let label = BasicLabel()
        switch chartType {
            case .pie:
                label.frame = CGRect(x: 0, y: 0, width: 100, height: 70)
            case .bar:
                label.frame = CGRect(x: 0, y: 0, width: 80, height: 50)
        }
        label.backgroundColor = .white.withAlphaComponent(0.8)
        label.layer.cornerRadius = 12
        label.layer.borderColor = UIColor(hexString: "#2042E9").cgColor
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    init(frame: CGRect,for chart: ChartType) {
        self.chartType = chart
        super.init(frame: .zero)
        makeLayout()
        makeConstraints()
    }
    
    private func makeLayout() {
        addSubview(label)
    }
    
    private func makeConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
         label.removeFromSuperview()
         

         let formatter = TextFormatter()
         switch chartType {
             case .pie:
                 let markerText = formatter.attrinutedLines(
                    main: entry.data as! String,
                    font: .custom(size: 12, weight: .regular),
                    secondary: "\(Int(entry.y)) Br",
                    secondaryFont: .custom(size: 14, weight: .medium),
                    secondaryColor: AppColors.black,
                    lineSpacing: 5,
                    aligment: .center
                 )
                 let markerLabelVM = BasicLabel.ViewModel()
                 markerLabelVM.textValue = .attributed(markerText)
                 label.setViewModel(markerLabelVM)
                 
             case .bar:
                 let markerText = formatter.attrinutedLines(
                    main: DateFormatter().standaloneMonthSymbols[Int(entry.x)].capitalized,
                    font: .custom(size: 12, weight: .regular),
                    secondary: "\(Int(entry.y)) Br",
                    secondaryFont: .custom(size: 14, weight: .medium),
                    secondaryColor: AppColors.black,
                    lineSpacing: 5,
                    aligment: .center
                 )
                 let markerLabelVM = BasicLabel.ViewModel()
                 markerLabelVM.textValue = .attributed(markerText)
                 label.setViewModel(markerLabelVM)

         }
         self.frame = label.bounds
         addSubview(label)
     }

    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        switch chartType {
            case .pie:
                return CGPoint(x: -40, y: -40)
            case .bar:
                return CGPoint(x: -40, y: -60)
        }
    }
}
