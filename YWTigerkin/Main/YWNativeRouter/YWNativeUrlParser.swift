//
//  YWNativeUrlParser.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit

class YWNativeUrlParser: NSObject {

    // 完整的Url路径
    // 例如完整的路径为：YWTK_goto://stock_quote?market=sh&code=600837
    // 则为：YWTK_goto://stock_quote?market=sh&code=600837
    var url : String
    
    // 去除了参数的Url路径
    // 例如完整的路径为：YWTK_goto://stock_quote?market=sh&code=600837
    // 则为：YWTK_goto://stock_quote
    public var baseUrl : String
    
    // 参数的字典
    // 例如完整的路径为：YWTK_goto://stock_quote?market=sh&code=600837
    // 则为：[[market : sh], [code : 600837]]
    var params = [String : String]()
    
    public init(_ urlString : String) {
        self.url = urlString

        let split = self.url.split(separator: "?", maxSplits: 1)

        self.baseUrl = String(split[split.startIndex])

        let queryString = (split.count > 1 ? split[1] : "")

        if !queryString.isEmpty {
            let paramString = queryString.split(separator: "#")[0]
            let params = paramString.split(separator: "&")
            for p in params {
                let kv = p.split(separator: "=")
                if kv.count == 2 {
                    self.params[String(kv[0])] = String(kv[1]).removingPercentEncoding
                }
            }
        }
    }
    
    public func getParam(withKey key : String) -> String? {
        return self.params[key]
    }
}
