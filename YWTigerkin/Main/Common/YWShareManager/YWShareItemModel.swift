//
//  YWShareItemModel.swift
//  YWTigerkin
//
//  Created by odd on 7/22/23.
//

import UIKit

class YWShareItemModel: NSObject {

    // 分享按钮标题
    var shareName: String?
    // 分享按钮类型
    var sharePlatform: YWSharePlatform = .ywUnknow
    // 分享按钮图片
    var shareImageName: String?
    
    // 字符串类型，用于web
    var shareType: String?
    var shareTag: NSInteger = 0
}
