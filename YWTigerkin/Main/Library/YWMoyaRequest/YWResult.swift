//
//  YWResult.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import Foundation

public struct YWResult<C: Codable>: Codable {
    public let statusCode: Int
    public let message: String?
    public let result: C?
    
    init(params:[String:Any], isCache: Bool) {
        if isCache {
            statusCode = YWResponseCode.dataCache.rawValue
        } else {
            statusCode = params["statusCode"] as? Int ?? 0
        }
        
        message = params["message"] as? String ?? ""
        
        if let resultDic = params["result"] {
            result = YWJSONAny.init(resultDic) as? C
        } else {
            result = nil
        }
    }
    
}

