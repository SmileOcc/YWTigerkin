//
//  YWConstant+Common.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import Foundation
import UIKit

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


extension YWConstant {
    
}
