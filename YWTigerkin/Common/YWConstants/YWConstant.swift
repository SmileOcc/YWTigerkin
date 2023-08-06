//
//  YWConstant.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import UIKit

@objc public enum YWTargetMode : Int {
    case dev    // 开发环境
    case sit    // 系统内部集成测试环境
    case uat    // 用户验收测试环境
    case mock   // 测试Mock环境
    case prd    // 生产环境
    case prd_hk // 生产环境（HK）
}

let KSCREEN_WIDTH = YWConstant.screenWidth
let KSCREEN_HEIGHT = YWConstant.screenHeight
let kNav_Height = YWConstant.navBarHeight

//判断表格数据空白页和分页的字段key
let kTotalPageKey = "pageCount"
let kCurrentPageKye = "curPage"
let kListKey = "list"

let kPageSize10 = 10
let kPageSize20 = 20

let kGoodsWidth = (KSCREEN_WIDTH - kPadding * 3.0) / 2.0
let kPadding:CGFloat        =     12.0
let kBottomPadding:CGFloat  =     12.0
let kColumnIndex2   =     2
let kColumnIndex3   =     3

class YWConstant: NSObject {

    @objc public static let sharedAppDelegate = UIApplication.shared.delegate
    
    class func kKeyWindow() -> UIWindow? {
        var  window: UIWindow? =  nil
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }.first?.windows
            .filter { $0.isKeyWindow }.first
        }
        else {
            window = UIApplication.shared.keyWindow
        }
        
        if window == nil {
            window = YWWAppDelegate?.window
        }
        return window
    }
    
    /// App类型
    @objc public enum YWAppType: Int {
        case CN         = 0x01        // 大陆版
        case HK         = 0x02        // 香港版
    }
    
    /**
     获取当前应用的BundleIdentifier

     @return BundleIdentifier
     */
    @objc public static let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String

    /**
     获取当前应用的名称

     @return 应用的名称
     */
    @objc public static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String

    /**
     获取当前应用的Build number

     @return Build number
     */
    @objc public static let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

    /**
     获取当前应用版本号

     @return 获应用版本号
     */
    @objc public static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    /**
     当前应用的appStore Url

     @return appStore Url
     */
    @objc public static let appStoreUrl = "https://itunes.apple.com/cn/app/id\(YWConstant.appId)?mt=8"

    /**
     当前应用的Review Url

     @return Review Url
     */
    @objc public static let appStoreReviewUrl = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(YWConstant.appId)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
    
    /**
     启动渠道
     e.g. @"友信渠道", @"1313"

     @return 启动渠道
     */
    @objc public static var launchChannel: String?
    
    /**
     注册邀请码
        默认“”

     @return 注册邀请码
     */
    @objc public static var registerICode: String? = ""
    
    /**
     来源于AAStock的哪个页面
     e.g. @"00001", @"00002"

     @return AAStock的来源页
     */
    @objc public static var AAStockPageName: String?
    
    
    /**
     来源于AAStock，是否完成过下单交易
      默认为true。如果从AAStock跳转过来，则会设置为false。

     @return 是否完成过下单交易
     */
    @objc public static var finishTradeAAStock: Bool = true
    
    /// 是否是由AAStock启动
    @objc public class func isLaunchedByAAStock() -> Bool {
        return YWConstant.launchChannel == "1313"
    }
    
    /// App版本号 64位
    @objc public static var appVersionValue: UInt64 {
        get {
            guard let array = YWConstant.appVersion?.components(separatedBy: ".") else { return 0 }
            assert(array.count <= 3, "version字符串格式不对")
            var valueString = ""
            (array as NSArray).enumerateObjects({ obj, idx, stop in
                if let str = obj as? String {
                    if str.count < 3 {
                        valueString += String(format: "%03d", Int(str) ?? 0)
                    } else {
                        valueString += str
                    }
                }

            })
            
            return UInt64(valueString) ?? 0

        }
    }
    
    /**
     获取当前appId

     @return appId
     */
    @objc public static var appId: String {
        if YWConstant.appTypeValue == .CN {
            return "123456"
        } else if YWConstant.appTypeValue == .HK {
            return "1234"
        } else {
            return "123"
        }
    }
    
    /// 获取当前AppType, String类型
    @objc public static var appType: String {
        if YWConstant.bundleId?.starts(with: "com.abce") ?? true {
            return "\(YWAppType.CN.rawValue)"
        } else if YWConstant.bundleId?.starts(with: "com.eeee") ?? true {
            return "\(YWAppType.HK.rawValue)"
        } else {
            return "\(YWAppType.CN.rawValue)"
        }
    }
    
    /// 获取当前AppType, YXAppType类型
    @objc public static var appTypeValue: YWAppType {
        if YWConstant.bundleId?.starts(with: "com.abce") ?? true {
            return YWAppType.CN
        } else if YWConstant.bundleId?.contains("eeee") ?? true {
            return YWAppType.HK
        } else {
            return YWAppType.CN
        }
    }
    
    
    @objc public static var logPubKey: String {
        if YWConstant.appTypeValue == .CN || YWConstant.appTypeValue == .HK  {
            return "e56a7bcb1ddcd59d08c6b20c7322d"
        } else {
            return "546fbb483422c1827c3cbd6ae9be1ea"
        }
    }
    
    @objc public static let logPath = "/YWTigerkin_Logs"
    
    @objc public static let firstLaunchKeyForHotStock = "firstLaunch_key_for_"
    
    @objc public static let berichRegionKey = "k_region_key"

}
