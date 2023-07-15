//
//  YWNavtiveRouterConstant.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit

public class YWNavtiveRouterConstant: NSObject {

    // 伪Scheme
    // 并未遵循苹果官方Scheme规范，因为直接使用UIApplication直接无法打开这个伪Scheme的Url
    public static let YWTK_SCHEME = "ywtk_goto://"
    
    /*
     用户登录
     例如：ywtk_goto://user_login
     */
    public static let GOTO_USER_LOGIN = YWTK_SCHEME + "user_login"
    
    /*
    1级页面 发现页tab
    例如：ywtk_goto://discover
    */
    public static let GOTO_DISCOVER = YWTK_SCHEME + "discover"
    
    /*
     “我的”菜单页
     例如：ywtk_goto://main_personal
     */
    public static let GOTO_MAIN_PERSONAL = YWTK_SCHEME + "main_personal"
}
