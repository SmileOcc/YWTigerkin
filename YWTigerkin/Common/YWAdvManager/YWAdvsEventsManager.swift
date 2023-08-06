//
//  YWAdvsEventsManager.swift
//  YWTigerkin
//
//  Created by odd on 3/24/23.
//

import UIKit


let kActiontype: String = "actiontype"
/**
 * 根据url解析Deeplink参数
 * ywtigerkin://action?actiontype=1&url=1&name=woment&source=deeplink
 */
class YWAdvsEventsManager: NSObject {
    
    static let instant = YWAdvsEventsManager()
    
    static func parseAdvsEventsModel(_ url:String) -> YWAdvsEventsModel {
        let paramDic = YWAdvsEventsManager.parseDeeplinkDic(url)
        let advModel:YWAdvsEventsModel = YWAdvsEventsManager.parseAdvsEventsModel(paramDic)
        return advModel
    }
    
    static func parseAdvsEventsModel(_ paramDic:[String:String]) -> YWAdvsEventsModel {
        let type = Int(paramDic[kActiontype] ?? "0") ?? 0
        
        let advModel:YWAdvsEventsModel = YWAdvsEventsModel()
        advModel.url = (paramDic["url"] ?? "").removingPercentEncoding
        advModel.actionType = AdvEventType.init(rawValue: type) ?? .unknow
        advModel.name = (paramDic["name"] ?? "").removingPercentEncoding
        advModel.params = paramDic
        return advModel
    }

    static func parseDeeplinkDic(_ url: String) -> [String:String] {
        
        var deeplinkParamDic:[String:String] = [:]
        var deeplinkAddress = url
        let componentKey = "actiontype="
        if url.contains(find: componentKey) {
            let componentObj = url.components(separatedBy: componentKey).last ?? ""
            deeplinkAddress = componentKey + componentObj
        }
        
        let arr = deeplinkAddress.components(separatedBy: "&")
        
        for str in arr {
            if (str as NSString).range(of: "=").location != NSNotFound {
                let key = str.components(separatedBy: "=").first ?? ""
                var value = ""
                if key == "url" {
                    value = (str as NSString).substring(from: 4)
                } else {
                    value = (str as NSString).components(separatedBy: "=").last ?? ""
                }
                
                var decodeValue = (value as NSString).removingPercentEncoding ?? ""
                // 防止多次编码,判断如果还有百分号就再解码一次
                if key == "url" && decodeValue.contains(find: "%") {
                    decodeValue = decodeValue.removingPercentEncoding ?? ""
                }
                if key.kLenght > 0 && decodeValue.kLenght > 0 {
                    deeplinkParamDic[key] = decodeValue
                }
            }
        }
        
        YWLog("\n================================ Deeplink 参数 =======================================\n👉: \(deeplinkParamDic)")
        return deeplinkParamDic
    }
    
     static func advEventTarget(target:Any?, advEventModel:YWAdvsEventsModel) {
        
        if let root = UIApplication.shared.delegate as? YWAppDelegate {
            
            let navigator = root.navigator
            
            func checkLogin(currentVC: UIViewController? = UIViewController.current(), needCheckOpenAccount: Bool = false, excuteBlock: @escaping (() -> Void)) {
                if YWUserManager.isLogin() {
                    excuteBlock()
                    
                } else {
                    let callback: (([String: Any])->Void)? = { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                            excuteBlock()

                        })
                    }
                    
                    let context = YWNavigatable(viewModel: YWLoginViewModel(callBack: callback, vc: currentVC))
//                    navigator.pushPath(YWModulePaths.login.url, context: context, animated: true)
                    navigator.presentPath(YWModulePaths.login.url, context: context, animated: true)
                }
            }
            
            if true {
                
                if advEventModel.actionType == .douYinVideo {
                    
                    let context = YWNavigatable(viewModel: YWDouYinVideoViewModel(), userInfo: ["type":"1"])
                    navigator.pushPath(YWModulePaths.douYinVidoe.url, context: context, animated: true)
                }
                
                
            } else {//需要登录
                
                checkLogin {
                   //事件处理
                }
                
            }
            
        }
    }
}
