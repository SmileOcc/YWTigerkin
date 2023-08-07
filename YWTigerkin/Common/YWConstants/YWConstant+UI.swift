//
//  YWConstant+UI.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import Foundation
import UIKit

extension YWConstant {
    
    @objc public static let screenFrame:CGRect = UIScreen.main.bounds

    /**
     屏幕宽度
     */
    @objc public static let screenWidth = UIScreen.main.bounds.size.width
    /**
     屏幕高度
     */
    @objc public static let screenHeight = UIScreen.main.bounds.size.height
    
    /**
     是否为X/XS/XR的拉伸比例

     @return 是/否
     */
    @objc public static func isIphoneX() -> Bool {
        let isPhoneX = (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0) > 0.0
        return isPhoneX
    }
    //iPhoneX 顶部间隙
    @objc public static let iphoneXTopSpace = YWConstant.isIphoneX() ? 24.0 : 0.0

    //导航栏高度
    @objc public static let navBarHeight = YWConstant.isIphoneX() ? 88.0 : 64.0

    //底部tab高度
    @objc public static let tabBarHeight = YWConstant.isIphoneX() ? 83.0 : 49.0

    //状态栏高度
    @objc public static let statusBarHeight = YWConstant.isIphoneX() ? 44.0 : 20.0

    //底部安全距离
    @objc public static let safeBottomHeight = YWConstant.isIphoneX() ? 34.0 : 0.0
    
    @objc public static let scale_375 = YWConstant.screenWidth / 375.0

    // 时间
    @objc public static let  sec_per_min   =  60
    @objc public static let  sec_per_hour  =  3600
    @objc public static let  sec_per_day   =  86400
    @objc public static let  sec_per_month =  2592000
    @objc public static let  sec_per_year  =  31104000
}


extension YWConstant {
    
    /// 顶部安全区高度
    static func xp_safeDistanceTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.top
    }
    
    /// 底部安全区高度
    static func xp_safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        
        guard let window = UIApplication.shared.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    }
    
    /// 顶部状态栏高度（包括安全区）
    static func xp_statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
        
}
