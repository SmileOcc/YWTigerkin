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
    case category = 2
    case news = 3
    case mine = 4
    case douYinVideo = 5
    
}

class YWAdvsEventsModel: NSObject, NSCoding {
    
    //跳转类型
    var actionType: AdvEventType = .unknow
    var url:String?
    var params:[String:String]?
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
    
    override init() {
        
    }
    
    func advActionType() -> AdvEventType {
        if let strUrl = url, strUrl.hasPrefix(YWLocalConfigManager.appDeeplinkPrefix()) {
            let parseMd = YWAdvsEventsManager.parseDeeplinkDic(strUrl)
            let type = Int(parseMd[kActiontype] ?? "0") ?? 0
            let eventType = AdvEventType.init(rawValue: type)
            return eventType ?? .unknow
        }
        return .unknow
    }

    func advActionUrl() -> String {
        
        return ""
    }
    
    

    init(_ specialModel:YWAdvEventSpecialModel?) {
        
        super.init()
        if let specialM = specialModel {
            self.actionType = specialM.pageType
            self.url = specialM.url
            self.name = specialM.name
            self.imageUrl = specialM.images
        }
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

