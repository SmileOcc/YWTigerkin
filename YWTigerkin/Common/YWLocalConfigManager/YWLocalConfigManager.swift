//
//  YWLocalConfigManager.swift
//  YWTigerkin
//
//  Created by odd on 8/2/23.
//

import Foundation
import UIKit

class YWLocalConfigManager {
    
    static func appScheme() -> String {
        return YWConstant.appName?.lowercased() ?? "YWTigerkin"
    }
    
    /// =========================== app deeplink配置信息  =========================== ///
    /// MARK: - app deeplink配置信息
    static func appDeeplinkPrefix() -> String {
        "ywtigerkin://action"
    }
    
    static func isRightToLeftLanguage() -> Bool {
        let language = YWUserManager.curLanguage()
        if language == .AR || language == .HE {
            return true
        }
        return false
    }
    
    // 从右到左
    static func isRightToLeftShow() -> Bool {
        if self.isRightToLeftLanguage() && UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            return true
        }
        return false
    }
}


