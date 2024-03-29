//
//  YWNetworkReachabilityManager.swift
//
//
//  Created by odd on 7/16/22.
//

import UIKit
import Alamofire

enum YWReachabilityStatus {
    case notRechable
    case unknown
    case ethernetOrWiFi
    case wwan
}

@objcMembers class YWNetworkReachabilityManager: NSObject {
    let ccc: NetworkReachabilityManager? = nil
    
    static let instance: YWNetworkReachabilityManager = YWNetworkReachabilityManager()

    class func shared() -> YWNetworkReachabilityManager {
        return instance
    }
    
    /// 返回一个布尔值,用于实时监测网络状态
    func isReachable() -> Bool {
        var res: Bool = false
        let netManager = NetworkReachabilityManager()
        if netManager?.status == .reachable(.ethernetOrWiFi) || netManager?.status == .reachable(.cellular) { res = true }
        return res
    }
    
    // 只能调用一次监听一次
    func netWorkReachability(reachabilityStatus: @escaping(YWReachabilityStatus) ->Void) {
        let manager = NetworkReachabilityManager.init()
        manager!.startListening { (status) in
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi) {
                reachabilityStatus(.ethernetOrWiFi)
            }
            
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.cellular) {
                reachabilityStatus(.wwan)

            }
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable {
                reachabilityStatus(.notRechable)
            }
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.unknown {
                reachabilityStatus(.unknown)

            }
        }
    }
}

