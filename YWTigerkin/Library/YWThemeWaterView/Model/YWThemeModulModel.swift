//
//  YWThemeModulModel.swift
//  YWTigerkin
//
//  Created by odd on 4/5/23.
//

import UIKit
enum YWThemeModuleType: Int {
    case unknow
    case cycleAdv
    case asingleAdv
}

class YWThemeModulModel: NSObject {

    var sort: String?
    var type: Int = 0
    var bgColor: String?
    var totalPage:Int = 0
    var currentPage:Int = 0
    
    //轮播广告 type = 1
    var cycleAdvList:[YWAdvEventSpecialModel]?
    
    //频道：type = 2
    var channelList:[YWThemeCThemeChannelModel]?
    //商品:type = 3
    var goodsList:[YWThemeCGoodsModel]?
    
    //单行:type = 4
    var oneAdvList:[YWAdvEventSpecialModel]?
    //双行:type = 5
    var twoAdvList:[YWAdvEventSpecialModel]?
    //滑动商品：type=6
    var slideList:[YWThemeCGoodsModel]?
    //新用户礼包 type=7
    var giftList:[Any]?
    //0元活动 type=8
    var zeroList:[YWThemeCGoodsModel]?
    //优惠券 type=9
    var couponList:[YWThemeCCouponModel]?
    
    //自定义 3/4 1/1 默认3/4
    var imageScale:Float = 3.0 / 4.0
}


class YWThemeCGoodsModel:NSObject {
    var goodsId:String = ""
    var goodsSku:String = ""
    var goodsTitle:String = ""
    var goodsNumber:String = ""
    var goodsImg:String?
    var goodsImgThum:String?
    
    var marketPrice:String = ""
    var shopPrice:String = ""
    
    var isCollect:Bool = false
    var collectCount:String = ""
    
    var isOnSale:Bool = false
}


class YWThemeCCouponModel: NSObject {
    var couponId:String = ""
    var couponCode:String = ""
    var type:String = ""
    var typeName:String = ""
    var dayTime:String = ""
    var title:String = ""
    var content:String = ""
    var expiryTime:String = ""
    var isReceived:Bool = false
    
}


class YWThemeCThemeChannelModel: NSObject {
    var name:String?
    var id:String?
    var sort:String?
    var goodsList:[YWThemeCGoodsModel]?
    
    var categoryId:String?
    var categoryName:String?
    
}
