//
//  YWLocalConfigManager.swift
//  YWTigerkin
//
//  Created by odd on 8/2/23.
//

import Foundation

class YWLocalConfigManager {
    
    static func appScheme() -> String {
        return YWConstant.appName?.lowercased() ?? "YWTigerkin"
    }
    
    /// =========================== app deeplink配置信息  =========================== ///
    /// MARK: - app deeplink配置信息
    static func appDeeplinkPrefix() -> String {
        "ywtigerkin://action"
    }
}


