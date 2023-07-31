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
     是否为4/4S的拉伸比例
     */
    @objc public static let deviceScaleEqualTo4S = UIScreen.main.bounds.size.height == 480
    /**
     是否为5/5S/SE的拉伸比例
     */
    @objc public static let deviceScaleEqualTo5S = UIScreen.main.bounds.size.height == 568
    /**
     是否为6S/7/8的拉伸比例
     */
    @objc public static let deviceScaleEqualTo6S = UIScreen.main.bounds.size.height == 667
    /**
     是否为6 Plus/7 Plus/8 Plus的拉伸比例
     */
    @objc public static let deviceScaleEqualToPlus = UIScreen.main.bounds.size.height == 736
    /**
     是否为X/XS/XR的拉伸比例

     @return 是/否
     */
    @objc public static func deviceScaleEqualToXStyle() -> Bool {
        var isPhoneX = false
        if #available(iOS 11.0, *) {
            isPhoneX = (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0) > 0.0
        }
        return isPhoneX
    }
    /**
     导航栏高度

     @return 导航栏高度
     */
    @objc public static let navBarHeight = YWConstant.deviceScaleEqualToXStyle() ? 88.0 : 64.0
    
    /**
     标签栏高度

     @return 标签栏高度
     */
    @objc public class func tabBarHeight() -> CGFloat {
        return YWConstant.deviceScaleEqualToXStyle() ? 83.0 : 49.0
    }
    /**
     导航栏偏移
     导航栏内容下移量(iPhoneX:44, 普通版无刘海, 不需偏移)

     @return 导航栏偏移
     */
    // 导航栏内容下移量(iPhoneX:44, 普通版无刘海, 不需偏移)
    @objc public class func navBarPadding() -> CGFloat {
        return YWConstant.deviceScaleEqualToXStyle() ? 44.0 : 0.0
    }

    /**
     底部标签栏区域上移量

     @return 标签栏上移量
     */
    // 底部tab区域上移量
    @objc public class func tabBarPadding() -> CGFloat {
        return YWConstant.deviceScaleEqualToXStyle() ? 34.0 : 0.0
    }

    @objc public static let statusBarHeight = YWConstant.deviceScaleEqualToXStyle() ? 44.0 : 20.0

    @objc public class func safeAreaInsetsBottomHeight() -> CGFloat {
        return YWConstant.deviceScaleEqualToXStyle() ? 34.0 : 0.0
    }
    
    @objc public static let safeBottom = tabBarPadding()

}
