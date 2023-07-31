//
//  YWH5Urls.swift
//  YWTigerkin
//
//  Created by odd on 7/28/23.
//

import UIKit

class YWH5Urls: NSObject {

    class func baseUrl() -> String {
        //测试数据
        return "https://baidu.com"
        return YWUrlRouterConstant.staticResourceBaseUrl()
    }
    
    // 隐私政策
    class func PRIVACY_POLICY_URL() -> String {
         baseUrl() + "?key=privacy_policy"
    }

    // 用户注册协议
    class func USER_REGISTRATION_AGREEMENT_URL() -> String {
        baseUrl() + "?key=registration_agreement" //"?key=AGR008"
    }

}
