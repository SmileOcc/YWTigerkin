//
//  AppDelegate+Notification.swift
//  YWTigerkin
//
//  Created by odd on 8/3/23.
//

import Foundation
import UIKit

extension AppDelegate {
    ///MARK: -广告推广
    func yw_applicationDeeplink(_ application: UIApplication, deeplink:URL, source:String, params:Any?) {
        self.isDeepLinkEventing = true
        
        let mdDic = YWAdvsEventsManager.parseDeeplinkDic(deeplink.absoluteString)
        ///如果deeplink需要跳转内部地址链接并且带有&参数的话，需要把 url的参数连续两次 encode
        YWLog("url = \(deeplink.absoluteString) \n query = \(deeplink.query ?? "") \n host = \(deeplink.host ?? "")")
        
        let advEventModel = YWAdvsEventsManager.parseAdvsEventsModel(mdDic)
        
        // 如果是推送跳转，则先提示用户是否打开
        let sourceApplication = "open"
        let source = mdDic["source"] ?? ""
        if source == "notifications" && sourceApplication == "open" {
            
        } else {
            
            if advEventModel.actionType == .unknow {
                self.isDeepLinkEventing = false
            }
        }
    }
    
    func yw_applyDeepLinkCalling(_ advEventModel: YWAdvsEventsModel) {
        ////从appsflyer 进来时不是主线程，回到主线程再操作UI
        if Thread.isMainThread == false {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                self.yw_applyDeepLinkCalling(advEventModel)
            })
        }
    }
}



//#pragma mark -===========AppsFlyerTrackerDelegate===========

//{
//    adgroup = "<null>";
//    "adgroup_id" = "<null>";
//    adset = "<null>";
//    "adset_id" = "<null>";
//    "af_click_lookback" = 7d;
//    "af_cpi" = "<null>";
//    "af_dp" = "xxxx://action?actiontype=3";
//    "af_siteid" = "<null>";
//    "af_status" = "Non-organic";
//    "af_sub1" = "<null>";
//    "af_sub2" = "<null>";
//    "af_sub3" = "<null>";
//    "af_sub4" = "<null>";
//    "af_sub5" = "<null>";
//    agency = "<null>";
//    campaign = "SMS_Adv";
//    "campaign_id" = "<null>";
//    channel = Facebook;
//    "click_time" = "2020-10-30 12:04:23.016";
//    "cost_cents_USD" = 0;
//    "engmnt_source" = "<null>";
//    "esp_name" = "<null>";
//    "http_referrer" = "http://api.xxxx.com.release.fpm.slktest.com/wap/download-app?lang=en&channel=Facebook&uid=0&device_id=06a6539fa7bd860e&currency=USD&version=1.1.2&platform=android&fbclid=IwAR3x0Eq5_aGj0cdAE82JIVe1LvOP3bxr8UvF7DUgz8oC6wEI2EKKDjcvc28";
//    "install_time" = "2020-10-30 12:06:07.890";
//    "is_branded_link" = "<null>";
//    "is_first_launch" = 0;
//    "is_universal_link" = "<null>";
//    iscache = 1;
//    "match_type" = probabilistic;
//    "media_source" = SMS;
//    "orig_cost" = "0.0";
//    "redirect_response_data" = "<null>";
//    "retargeting_conversion_type" = none;
//    uid = 0;
//    url = "7803,2";
//}
