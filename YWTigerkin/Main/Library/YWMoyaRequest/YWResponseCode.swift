//
//  YWResponseCode.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import UIKit

@objc public enum YWResponseCode: Int {
  
    case success = 0
    case unsetLoginPwd        = 300705 //未设置登录密码
    case invalidRequest       = 300100 //非法请求
    case accountTokenFailure  = 300101 //token失效
    
    case dataCache = 100010001000
}
