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
}

extension Object {
    func toDictionary() -> NSDictionary {
        let properties = self.objectSchema.properties.map { $0.name }
        let dictionary = self.dictionaryWithValues(forKeys: properties)
        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)
        
        for prop in self.objectSchema.properties {
            if let nestedObject = self[prop.name] as? Object {
                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
            }
        }
        return mutabledic
    }
}
