//
//  YWAdvsEventsModel.swift
//  YWTigerkin
//
//  Created by odd on 3/24/23.
//

import UIKit

enum AdverType: Int {
    case unknow = 0
    //开机
    case launch = 1
    //首页活动
    case homeActity
    //首页广告
    case homeBanner
}

enum AdvEventType: Int {
    case unknow = 0
    case home = 1
    case cateogry = 2
    case message = 3
    case account = 4
    case search = 5
}

class YWAdvsEventsModel: NSObject, NSCoding {
    
    //跳转类型
    var actionType: AdvEventType = .unknow
    var url:String?
    //标题
    var name:String?
    //id
    var cid:String?
    var isShare: Bool = false
    //分享标题
    var shareTitel:String?
    //图片路径
    var imageUrl:String?
    //分享地址
    var shareLinkUrl:String?
    //广告弹窗次数
    var popupNumber:String?
    
    // banner字典数据
    var info:[String:Any]?
    
    var advType:AdverType = .unknow
    
    var banner_heigth:String?
    var banner_width:String?
    
    
    func encode(with coder: NSCoder) {
        
    }
    
    required init?(coder: NSCoder) {
        
    }
    
    func advActionType() -> AdvEventType {
        
        return .unknow
    }

    func advActionUrl() -> String {
        
        return ""
    }
    
 
}


class YWAdvEventSpecialModel: NSObject {
    var images:String?
    var pageType:AdvEventType = .unknow
    var shareImg:String?
    var shareTitle:String?
    var imageWidth:String?
    var imageHdight:String?
    var isShare:String?
    var shareUrl:String?
    var shareDoc:String?
    var url:String?
    var name:String?
    
}

