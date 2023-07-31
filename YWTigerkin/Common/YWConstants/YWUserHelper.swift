//
//  YWUserHelper.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import UIKit


fileprivate let YWUser =        "YWUser"
fileprivate let YWLanguage =    "YWLanguage"
fileprivate let YWUserToken =   "YWUserToken"
fileprivate let YWUserUUID =    "YWUser_UUID"

fileprivate let YWCurBroker = "YWCurBroker"   //当前登陆的券商
fileprivate let YWCurBrokerToken = "YWCurBrokerToken"   //当前登陆的券商

@objcMembers public class YWUserHelper: NSObject {
    
    @objc public static func currentUUID() -> UInt64 {
        var uuid: UInt64 = 0
        
        if let obj = MMKV.default()?.object(of: NSNumber.self, forKey: YWUserUUID) as? NSNumber {
            uuid = obj.uint64Value
        }
        
        if uuid < 1 {
            let service = YWKeyChainUtil.serviceName(serviceType: .Guest, bizType: .GuestUUID)
            let account = YWKeyChainUtil.accountName(serviceType: .Guest)
            if let uuidString = SAMKeychain.password(forService: service, account: account) {
                uuid = UInt64(uuidString) ?? 0
            }
        }
        
        return uuid
    }
    
    @objc public static func currentToken() -> String {
        if let token = MMKV.default()?.string(forKey: YWUserToken) {
            return token
        }
        return ""
    }
    
}
