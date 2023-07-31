//
//  YWGlobalConfigManager.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import UIKit

@objc class YWGlobalConfigManager: NSObject {

    @objc public static let shareInstance = YWGlobalConfigManager()

    private var globalConfigModel: YWGlobalURLConfigModel?
    private var lastConfigKey: String = ""
    
    /// 证书双向校验开关 1开，0关
    @objc public class func isCertificateCheckOn() -> Bool {
        YWGlobalConfigManager.shareInstance.decodeGlobalConfigModel()
        if let value = YWGlobalConfigManager.shareInstance.globalConfigModel?.parameter?.certificateCheck {
            return value == 1
        }
        return true
    }
    
    private func decodeGlobalConfigModel() {

        let canConfig = YWConstant.isGlobalConfig()
        if canConfig || YWConstant.targetMode() == .prd || YWConstant.targetMode() == .prd_hk {
            let configKey = YWGlobalConfigManager.getGlobalUrlConfigKey()
            if YWGlobalConfigManager.shareInstance.globalConfigModel == nil ||  YWGlobalConfigManager.shareInstance.lastConfigKey != configKey {
                if let data = MMKV.default()?.object(of: NSData.self, forKey: configKey) as? Data,
                    let model = try? JSONDecoder().decode(YWGlobalURLConfigModel.self, from: data) {
                    YWGlobalConfigManager.shareInstance.lastConfigKey = configKey
                    YWGlobalConfigManager.shareInstance.globalConfigModel = model
                }
            }
        } else {
            YWGlobalConfigManager.shareInstance.globalConfigModel = nil
        }
    }
}


extension YWGlobalConfigManager {
    
    @objc class func getGlobalUrlConfigKey() -> String {
        // 每个环境都单独保存自己环境的配置
        return "YWGlobalUrlConfigKey-".appending(YWConstant.targetModeName()!)
    }
    
    @objc class func getCountryAreaModelKey() -> String {
       // 每个环境都单独保存自己环境的配置
       // model有变化，之前的不能再使用,添加【-V1】启用新的key，
       return "YWCountryAreaModelKey-V1-".appending(YWConstant.targetModeName()!)
    }
    
    @objc class func getCountryAreaRequestKey() -> String {
        return "getCountryAreaRequestKey-".appending(YWConstant.targetModeName()!)
    }
    
    @objc class func getCustomerModelKey() -> String {
        // 每个环境都单独保存自己环境的配置
        return "YWCustomerModelKey-".appending(YWConstant.targetModeName()!)
    }
    
    @objc public class func getFilterModuleKey() -> String {
        // 每个环境都单独保存自己环境的配置
        return "YWFilterModuleKey-".appending(YWConstant.targetModeName()!)
    }
}
