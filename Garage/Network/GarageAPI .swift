//
//  GarageAPI .swift
//  Garage
//
//  Created by Illia Romanenko on 8.06.23.
//

import Foundation
import Moya

enum GarageApi {
    case brands
    case models(brand: String)
    case decodeWIN(win: String)
    case getLogo(brand: String)
    case news
}

extension GarageApi: TargetType {
    var baseURL: URL {
        switch self {
        case .getLogo, .news:
            return URL(string: "https://pictures.shoop-vooop.cloudns.nz/")!
        default:
            return URL(string: "https://vpic.nhtsa.dot.gov/api")!
        }
    }

    var path: String {
        switch self {
        case .decodeWIN(let win):
            return "/vehicles/decodevin/\(win)"
            
        case .brands:
            return "/vehicles/getallmakes"
            
        case .models(let brand):
            return "/vehicles/getmodelsformake/\(brand)"

        case .getLogo(let brand):
            return "cars-logos/api/images/\(brand)_resized.png"
            
        case .news:
            return "shopping-list/api/news"
        }
        
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        guard let params else { return .requestPlain}
        
        return .requestParameters(parameters: params, encoding: encoding)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var params: [String : Any]? {
        var params = [String : Any]()
        switch self {
        case .getLogo:
            return nil
        default:
            params["format"] = "json"
        }
        return params
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.queryString
        }
    }
    
}
