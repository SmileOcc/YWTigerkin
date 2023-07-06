//
//  YWApplePayProduct.swift
//  YWTigerkin
//
//  Created by odd on 6/18/23.
//

import UIKit

class YWApplePayResult: NSObject {
    var isSuccess: Bool = false
    var msg: String?
    var logMsg: String?
    
    //对应产品
    var product:YWApplePayProduct?
    //对应票据
    var receipt:String?
    
    //默认创建
    static func defaultModel() -> YWApplePayResult {
        return YWApplePayResult()
    }
}

class YWApplePayProduct: NSObject {

    var title:String?
    //appstore上的产品ID
    var productId:String = ""
    var price:String?
    var count:Int = 1
}
