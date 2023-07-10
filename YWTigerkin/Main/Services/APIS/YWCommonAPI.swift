//
//  YWCommonAPI.swift
//  YWTigerkin
//
//  Created by odd on 7/1/23.
//

import Foundation
import Moya

let commonProvider = MoyaProvider<YWCommonAPI>(requestClosure: requestTimeoutClosure, session : YWMoyaConfig.session(), plugins: [YWNetworkLoggerPlugin(verbose: true)])

public enum YWCommonAPI {
    
    case videoList(_ type: String, page: String, pageSize: String)

}

extension YWCommonAPI: YWTargetType {
    public var requestCache: Bool? {
        false
    }
    
    
    public var path: String {
        switch self {
       
        case .videoList:
             return servicePath + "videoList/v1"
        
        }
    }
    
    public var task: Task {
        var params: [String: Any] = [:]
        switch self {
        
        case .videoList(let type, let page, let pageSize):
            params["type"] = type
            params["page"] = page
            params["pageSize"] = pageSize

            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var baseURL: URL {
        return URL(string: YWUrlRouterConstant.hzBaseUrl())!

    }
    
    public var requestType: YWRequestType {
        return .hzRequest
        
    }
    
    public var servicePath: String {
        switch self {
        case
            .videoList:
            return "/common-server/api/"
        default:
            return "/common-server/api/"
        }
    }
    
    public var method: Moya.Method {
        .post
    }
    
    public var headers: [String : String]? {
        var headers = yw_headers
        if let contentType = contentType {
            headers["Content-Type"] = contentType
        }
        
        
        return headers
    }
    
    public var contentType: String? {
        "application/json"
    }
    
    public var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
}
