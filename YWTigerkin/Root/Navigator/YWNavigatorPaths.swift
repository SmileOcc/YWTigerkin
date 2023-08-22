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
    //MARK: - 我的
    case userCenter
 
    // 用户中心-设置
    case userCenterSet
        
    //MARK: - 搜索
    case search
    case searchResut
    
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
    
    //MARK: - 购物车
    case cart
    //MARK: - 订单
    case orderCenter
    case orderList
    case orderDetail
    //MARK: - 消息
    case messageCenter
    
    //MARK: - 活动中心
    case activityCenter
    
    
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
        case .searchResut:
            return "search/result/"
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
        case .cart:
            return "cart/"
        case .orderCenter:
            return "orderCenter/"
        case .orderList:
            return "orderList/"
        case .orderDetail:
            return "orderDetial/"
        case .messageCenter:
            return "messageCenter/"
        case .activityCenter:
            return "activityCenter/"
        }
    }
    
    var url: String {
        scheme + path
    }
}
