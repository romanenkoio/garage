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
}

extension GarageApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://vpic.nhtsa.dot.gov/api")!
    }
    
    var path: String {
        switch self {
        case .decodeWIN(let win):
            return "/vehicles/decodevin/\(win)"
            
        case .brands:
            return "/getallmakes"
            
        case .models(let brand):
            return "getmodelsformake/\(brand)"
            
        default:
            return ""
        }
        
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var params: [String : Any]? {
        var params = [String : Any]()
        switch self {
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
