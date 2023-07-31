//
//  YWNavigatorPaths.swift
//  YWTigerkin
//
//  Created by odd on 3/3/23.
//

import Foundation
public protocol YWModuleType {
    var scheme: String { get }
    
    var path: String { get }
    
    var url: String { get }
}

@objc protocol YWModulePathServices {
    @objc func pushPath(_ path: YWModulePaths, context: Any?, animated: Bool)
    @objc func presentPath(_ path: YWModulePaths, context: Any?, animated: Bool, completion: (() -> Void)?)
}

@objc enum YWModulePaths: Int {

    //登录
    case login
    // 用户中心
    case userCenter
 
    // 用户中心-设置
    case userCenterSet
    
    // 搜索
    case search
    
    // 视频
    case video
    
    // 其他
    case settingOther
    
    // 支付
    case payCenter
    
    // 抖音视频
    case douYinVidoe
    
    // 网页
    case webPage
    
    
}

let NavigatiorScheme = "ywtigerkin://"

extension YWModulePaths: YWModuleType {
    var scheme: String {
        NavigatiorScheme
    }
    
    var path: String {
        switch self {
        case .login:
            return "user/login/"
        case .userCenter:
            return "userCenter/"
        case .userCenterSet:
            return "userCenter/set/"
        case .search:
            return "search/"
        case .video:
            return "video/"
        case .settingOther:
            return "setting/other/"
        case .payCenter:
            return "payCenter/"
        case .douYinVidoe:
            return "douYinVideo/"
        case .webPage:
            return "webPage/"
        }
    }
    
    var url: String {
        scheme + path
    }
}
