//
//  YWUrlRouterConstant.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import UIKit

public class YWUrlRouterConstant: NSObject {
    #if PRD || PRD_HK
    static public let SCHEME = "https://"
    #else
    static public let SCHEME = "http://"
    #endif

    static public var ipAddressStatus : [String : Bool] = [:]


    // 校验证书时用
    class public func appHttpsEvaluatorsKey() -> String {
        switch YWConstant.appTypeValue {
        case .CN:
            return "*.abce.com"
        case .HK:
            return "*.eeee.com"
        default:
            return "*.abce.com"
        }
    }

    /// 设置IP的状态，如果出现过超时，则标记为不可访问
    /// - Parameters:
    ///   - IP: 指定IP
    ///   - status: 状态
    class public func setStatus(IP: String, status: Bool) {
        YWUrlRouterConstant.ipAddressStatus[IP] = status
    }
    
    /// 判断给定的IP是否被可用
    /// - Parameter ipAddress: 给定的IP
    /// - Returns: 是否曾经被标记过访问不同，如果被标记过返回false，未被标记过返回true
    class public func ipAddressHitTest(ipAddress: String) -> Bool {
        if YWUrlRouterConstant.ipAddressStatus.keys.contains(ipAddress) {
            return YWUrlRouterConstant.ipAddressStatus[ipAddress] ?? true
        }
        return true
    }
    
    /// 从给定的IP池中返回可用的IP
    /// - Parameter ipPools: 指定的IP池
    /// - Returns: 可用的IP
    class func decideIPAddress(ipPools: [String]) -> String? {
        var result: String?
        
        for ip in ipPools {
            if ipAddressHitTest(ipAddress: ip) {
                result = ip
                break
            }
        }
        return result
    }
    
    /// 移动端静态资源BaseUrl
    ///
    /// - Returns: 移动端静态资源BaseUrl
    class public func staticResourceBaseUrlForShare() -> String {
        switch YWConstant.targetMode() {
        case .dev:
            return SCHEME + "dev.abc.com"
        case .sit:
            return SCHEME + "dev.abc.com"
            
        default:
            return SCHEME + "dev.abc.com"
        }
    }
    
    /// sg跳转到pc静态资源BaseUrl
    ///
    /// - Returns: 静态资源BaseUrl
    
    class public func pcStaticResourceBaseUrl() -> String {
        var baseUrl = ""
        switch YWConstant.targetMode() {
        case .sit:
            baseUrl = SCHEME + "www-sit.abc.com"
        case .uat:
            baseUrl = SCHEME + "www-uat.abc.com"
        default:
            baseUrl = SCHEME + "www.abc.com"
            break
        }
        return baseUrl
    }
    
    /// 移动端静态资源BaseUrl
    ///
    /// - Returns: 移动端静态资源BaseUrl
    class public func staticResourceBaseUrl() -> String {
        switch YWConstant.targetMode() {
        case .dev:
            return SCHEME + "dev.abc.com"
            
        case .sit:
            return SCHEME + "dev.abc.com"
            
        default:
            return SCHEME + "dev.abc.com"
            
        }
    }

    
    
    class public func hzBaseUrl() -> String {
        // 1. 首先看是否打开了备份机房开关，如果打开了则使用备份机房域名
        // 2. 先看腾讯云httpdns是否解析出了IP，如果解析出来了则使用腾讯云的ip
        // 3. 全局配置Url是否能够解析成功，则使用全局配置Url
        // 4. 如果全局配置解析失败，则使用全局配置的IP地址请求
        // 5. 如果全局配置没有配置IP地址，则使用内置域名
        // 6. 如果内置域名解析失败，则使用内置IP
        
        if YWConstant.appTypeValue == .HK {
            return hzBuildInBaseUrl()
        }
        //    else if let ip = YWDNSResolver.shareInstance().httpDNSIp(with: .hzGlobalConfig) {
        //        if ip.lowercased().hasPrefix("http") {
        //            return ip
        //        } else {
        //            return SCHEME + ip
        //        }
        //    } else if let url = YWGlobalConfigManager.configURL(type: .hzCenter),
        //        YWDNSResolver.shareInstance().hostStatus(with: .hzGlobalConfig) {
        //        return url
        //    } else if let ip = decideIPAddress(ipPools: YWGlobalConfigManager.bizIPs(type: .hzCenter)) {
        //        if ip.lowercased().hasPrefix("http") {
        //            return ip
        //        } else {
        //            return SCHEME + ip
        //        }
        //    } else if YWDNSResolver.shareInstance().hostStatus(with: .hzBuildIn) {
        //        return hzBuildInBaseUrl()
        //    }
        else if let ip = decideIPAddress(ipPools: hzIPUrl()) {
            return ip
        }
        return hzBuildInBaseUrl()
    }
    
    class public func hzBuildInBaseUrl() -> String {
        return SCHEME + hzBaseUrlWithoutScheme()
    }
    
    /// 行情资讯BaseUrl
    /// - Returns: 行情资讯BaseUrl
    class public func hzBaseUrlWithoutScheme() -> String {
        switch YWConstant.targetMode() {
        case .dev:
            if YWConstant.appTypeValue == .HK {
                return "zt-uat.xxxx.com"
            }  else {
                return "hz-dev.yyyy.com"
            }
        case .sit:
            if YWConstant.appTypeValue == .HK {
                return "zt-uat.xxxx.com"
            } else {
                return "hz-dev.yyyy.com"
            }
            
        case .mock:
            return "10.211.110.93:9898/mockhqzx"
        default:
            
            return "hz.abc.com"
        }
    }
    
    
    
    /// 图片资源BaseUrl
    ///
    /// - Returns: 图片资源BaseUrl
    class public func imgResourceBaseUrl() -> String {
        switch YWConstant.targetMode() {
        case .dev:
            return SCHEME + "img-dev.abce.com"
        case .sit:
            return SCHEME + "img-sit.abce.com"
        case .uat:
            return SCHEME + "img1-uat.abce.com"
        case .mock:
            return SCHEME + "10.211.110.93:9898/mockimage"
        case .prd, .prd_hk:
            return SCHEME + "img.abc.com"
        }
    }
    


    /// 内置的行情IP地址，用于在域名请求或DNS解析失败时的备用
    /// - Returns: 所有备用的IP地址【带SCHEME】
    class public func hzIPUrl() -> [String] {
        let IPUrls = hzIPUrlWithoutScheme().map { (url) -> String in
            return SCHEME + url
        }
        
        return IPUrls
    }
    
    /// 内置的行情IP地址，用于在域名请求或DNS解析失败时的备用
    /// - Returns: 所有备用的IP地址【不带SCHEME】
    class public func hzIPUrlWithoutScheme() -> [String] {
        switch YWConstant.targetMode() {
        case .dev:
            return ["10.11.4.13"]
        case .sit:
            return ["10.11.4.33"]
        case .uat:
            return ["10.11.4.128", "10.11.4.70"]
        case .mock:
            return ["10.11.4.33"]
        case .prd,
             .prd_hk:
            return ["111.19.43.245",
                    "111.770.150.199",
                    ]

        }
    }
}
