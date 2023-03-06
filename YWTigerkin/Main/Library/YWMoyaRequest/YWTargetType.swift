//
//  YWTargetType.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import Foundation
import Moya
import MMKV

@objc public enum YWRequestType: Int {
    case hzRequest
    case jyRequest
    case wjRequest
    case zxRequest
}

public extension YWTargetType {
    var yw_headers: [String: String] {
        
        var headers = YWHeaders.httpHeaders()

        if let contentType = contentType {
            headers["Content-Type"] = contentType
        }
        
        switch self.requestType {
        case .hzRequest:
            headers["Host"] = YWUrlRouterConstant.hzBaseUrlWithoutScheme()
        case .jyRequest:
            headers["Host"] = YWUrlRouterConstant.hzBaseUrlWithoutScheme()

        case .wjRequest:
            headers["Host"] = YWUrlRouterConstant.hzBaseUrlWithoutScheme()

        case .zxRequest:
            headers["Host"] = YWUrlRouterConstant.hzBaseUrlWithoutScheme()

        }
        
        return headers
    }
}

public protocol YWTargetType: TargetType {
    
    var servicePath: String { get }
    var contentType: String? { get }
    var requestType: YWRequestType { get }
}

@objc public class YWHeaders: NSObject {
    @objc public class func httpHeaders() -> [String: String] {
        let xTransId = NSUUID().uuidString
        let xTime = "\(Int64(Date().timeIntervalSince1970 * 1000))"
        let xDt = "t2" //t2代表苹果
        let xDevId = YWConstant.deviceUUID
        let xUid = "\(YWUserHelper.currentUUID())"
        let xLang = "cn" //语言 1-简体  2-繁体  3-英文
        let xType = YWConstant.appType  //app类型 1-大陆版  2-港版
        let xVer = YWConstant.appVersion ?? ""
        let xToken = ""

        // downloadCid：下载渠道id,默认为AppStore
        let downloadCid = "AppStore"

        // registerCt：注册渠道类型
        let registerCt = YWConstant.launchChannel?.isEmpty ?? true ? "1" : "ecp"

        
        // registerICode：注册邀请码
        let registerICode: String = YWConstant.registerICode ?? ""
        
 
        var headers: [String: String] = ["Authorization": YWUserHelper.currentToken(),
                                        "X-Ver"        : xVer,
                                        "X-Dt"         : xDt,
                                        "X-Time"       : xTime,
                                        "X-Trans-Id"   : xTransId,
                                        //"X-Net-Type"   : YWNetworkUtil.sharedInstance().networkType(),
                                        "X-Uid"        : xUid,
                                        "X-Dev-Info"   : YWConstant.deviceInfo(),                                                  //设备信息
                                        "X-Lang"       : xLang,
                                        "X-Type"       : xType,
                                        "X-Dev-Id"     : xDevId,
                                        "X-Token"      : xToken,
                                        ]
        
        if YWConstant.appTypeValue == .HK {
            headers["X-Region"] = String("HK")
        }else if YWConstant.appTypeValue == .CN {
            headers["X-Region"] = "cn"
        }else {
            headers["X-Region"] = nil
            headers["X-BrokerNo"] = nil
            headers["BrokerAuthorization"] = nil
        }
        // 这个字段用于控制是否开启双向证书校验,在生产环境下,默认是开启双向校验的
        if headers["X-Challenge"] == nil {
            if YWGlobalConfigManager.isCertificateCheckOn() == false {
                headers["X-Challenge"] = "Cancel"
            }
        }
    
        return headers
    }
}
