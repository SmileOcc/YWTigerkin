//
//  YWConstant+Common.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import Foundation
import UIKit


//color
func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) ->UIColor {
    return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

let ColorWhiteAlpha10:UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.1)
let ColorWhiteAlpha20:UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.2)
let ColorWhiteAlpha40:UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.4)
let ColorWhiteAlpha60:UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.6)
let ColorWhiteAlpha80:UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.8)

let ColorBlackAlpha5:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.05)
let ColorBlackAlpha10:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.1)
let ColorBlackAlpha20:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.2)
let ColorBlackAlpha40:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.4)
let ColorBlackAlpha60:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.6)
let ColorBlackAlpha80:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.8)
let ColorBlackAlpha90:UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.9)

let ColorThemeGrayLight:UIColor = RGBA(r:104.0, g:106.0, b:120.0, a:1.0)
let ColorThemeGray:UIColor = RGBA(r:92.0, g:93.0, b:102.0, a:1.0)
let ColorThemeGrayDark:UIColor = RGBA(r:20.0, g:21.0, b:30.0, a:1.0)
let ColorThemeYellow:UIColor = RGBA(r:250.0, g:206.0, b:21.0, a:1.0)
let ColorThemeYellowDark:UIColor = RGBA(r:235.0, g:181.0, b:37.0, a:1.0)
let ColorThemeBackground:UIColor = RGBA(r:14.0, g:15.0, b:26.0, a:1.0)

let ColorThemeRed:UIColor = RGBA(r:241.0, g:47.0, b:84.0, a:1.0)

let ColorRoseRed:UIColor = RGBA(r:220.0, g:46.0, b:123.0, a:1.0)
let ColorClear:UIColor = UIColor.clear
let ColorBlack:UIColor = UIColor.black
let ColorWhite:UIColor = UIColor.white
let ColorGray:UIColor =  UIColor.gray
let ColorBlue:UIColor = RGBA(r:40.0, g:120.0, b:255.0, a:1.0)
let ColorGrayLight:UIColor = RGBA(r:40.0, g:40.0, b:40.0, a:1.0)
let ColorGrayDark:UIColor = RGBA(r:25.0, g:25.0, b:35.0, a:1.0)
let ColorSmoke:UIColor = RGBA(r:230.0, g:230.0, b:230.0, a:1.0)


//Font
let SuperSmallFont:UIFont = UIFont.systemFont(ofSize: 10.0)
let SuperSmallBoldFont:UIFont = UIFont.systemFont(ofSize: 10.0)

let SmallFont:UIFont = UIFont.systemFont(ofSize: 12.0)
let SmallBoldFont:UIFont = UIFont.systemFont(ofSize: 12.0)

let MediumFont:UIFont = UIFont.systemFont(ofSize: 14.0)
let MediumBoldFont:UIFont = UIFont.systemFont(ofSize: 14.0)

let BigFont:UIFont = UIFont.systemFont(ofSize: 16.0)
let BigBoldFont:UIFont = UIFont.systemFont(ofSize: 16.0)

let LargeFont:UIFont = UIFont.systemFont(ofSize: 18.0)
let LargeBoldFont:UIFont = UIFont.systemFont(ofSize: 18.0)

let SuperBigFont:UIFont = UIFont.systemFont(ofSize: 26.0)
let SuperBigBoldFont:UIFont = UIFont.systemFont(ofSize: 26.0)

public enum ScreenPiexlScale: NSInteger {
    case scale1X
    case scale2X
    case scale3X
}

//获取 图片
public func getImage(name:String) -> UIImage? {
    if name.count == 0 { return nil}
    var tempName: String = name
    if !(name.hasSuffix("@2x") || name.hasSuffix("@3x")) {
        tempName = name + "@2x"
        tempName = name + "@3x"
//        if YWConstant.screenPiexlScale == .scale3X {
//        }
    }
    if let path = Bundle.main.path(forResource: tempName, ofType: "png") {
        return UIImage.init(contentsOfFile: path)
    }
    return UIImage.init(named: name)
}
/**
 适配的宽度比
 */
private let unifomHeight = UIScreen.main.bounds.size.height / 812.0
/**
 适配的高度比
 */
private let unifomWidth = UIScreen.main.bounds.size.width / 375.0
/// 等比例高度
///
/// - Parameter height: 原来的高度
/// - Returns: 统一后的高度
public func uniVerLength(_ height:CGFloat) -> CGFloat {
    unifomHeight * height
}
public func uniVerLength(_ height:CGFloat,uniHeight:CGFloat) -> CGFloat {
    UIScreen.main.bounds.size.height / uniHeight * height
}
/// 等比例宽度
///
/// - Parameter height: 原来的宽度
/// - Returns: 统一后的宽度
public func uniHorLength(_ width:CGFloat) -> CGFloat {
    unifomWidth * width
}
public func uniHorLength(_ width:CGFloat,uniWidth:CGFloat) -> CGFloat {
    UIScreen.main.bounds.size.width / uniWidth * width
}
/// 等比例文字大小
///
/// - Parameter height: 原来的文字大小
/// - Returns: 统一后的文字大小
public func uniSize(_ size:CGFloat) -> CGFloat {
    unifomWidth * size
}

/// 强制设置某种语言
///
/// - Parameter key: 某个文字的key
/// - Returns: 统一后的文字大小
public func forceLocalized(withKey key:String) {
//    var language = ""
//    switch YWUserManager.curLanguage() {
//    case .CN:
//        // 简体中文
//        language = "zh-Hans"
//    case .EN:
//        // 英文
//        language = "en"
//    case .HK:
//        language = "zh-Hant"//"zh-HK"
//    default:
//        language = "en"
//    }
//    if let path = Bundle.main.path(forResource: language, ofType: "lproj"),path.count > 0 {
//        Bundle(path: path)?.localizedString(forKey: key, value: nil, table: "Localizable")
//    }
}

//notification
let StatusBarTouchBeginNotification:String = "StatusBarTouchBeginNotification"


extension YWConstant {
    static let requestLoading = "加载中..."
    static let requestFail = "请求失败"
    static let requestNetError = "网络异常，请稍后重试"
    static let requestNoData = "暂无数据"
    
}
