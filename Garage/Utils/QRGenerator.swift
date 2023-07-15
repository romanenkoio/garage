//
//  QRGenerator.swift
//  Garage
//
//  Created by Illia Romanenko on 4.07.23.
//

import UIKit
import RealmSwift

final class QRGenerator<T: Object> {
    func generateQRCode(from object: T) -> UIImage? {
        do {
            let data = object.toDictionary()
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)

            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(jsonData, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 3, y: 3)

                if let output = filter.outputImage?.transformed(by: transform) {
                    return UIImage(ciImage: output)
                }
            }

            return nil
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func readQRImage(_ image: UIImage) -> String? {
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh]),
              let ciImage = CIImage(image: image),
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature]
        else { return nil }
        
        var qrCodeLink = String.empty
        
        for feature in features {
            qrCodeLink += feature.messageString.wrapped
        }

        return qrCodeLink.isEmpty ? nil : qrCodeLink
    }
}

extension Object {
    func toDictionary() -> [String: Any] {
        let properties = self.objectSchema.properties.map { $0.name }
        let dictionary = self.dictionaryWithValues(forKeys: properties)
        
        return dictionary
    }
}
