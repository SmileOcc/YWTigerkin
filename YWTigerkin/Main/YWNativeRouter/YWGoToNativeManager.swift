//
//  YWGoToNativeManager.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit
import Foundation

class YWGoToNativeManager: NSObject, YWGotoNativeProtocol {
    

    @objc static let shared = YWGoToNativeManager()
    
    private override init() {
        
    }
    
    override func copy() -> Any {
        self
    }
    
    override func mutableCopy() -> Any {
        self
    }
    
    // Optional
    func reset() -> Void {
        // Reset all properties to default value
    }
    
    @objc func schemeHasPrefix(string : String) -> Bool {
        return string.hasPrefix(YWNavtiveRouterConstant.YWTK_SCHEME)
    }
    
    func gotoNativeViewController(withUrlString urlString: String) -> Bool {
        
        if urlString.isEmpty {
            return false
        }
        
//        let result = urlString.replacingOccurrences(of: YWNativeRouterConstant.YWTK_SCHEME, with: YWNativeRouterConstant.YWTK_SCHEME)
        let result = urlString

        let parser = YWNativeUrlParser(result)
        
        if let root = UIApplication.shared.delegate as? YWAppDelegate {
            
            let navigator = root.navigator
            
//            func checkLogin(currentVC: UIViewController? = UIViewController.current(), needCheckOpenAccount: Bool = false, excuteBlock: @escaping (() -> Void)) {
//                if YXUserManager.isLogin() {
//                    if needCheckOpenAccount {
//                        if YXUserManager.canTrade() {
//                            excuteBlock()
//                        }else {
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXUserManager.notiUpdateResetRootView), object: nil, userInfo: ["index" : YXTabIndex.holding])
//                        }
//                    }else {
//                        excuteBlock()
//                    }
//
//                } else {
//                    let callback: (([String: Any])->Void)? = { _ in
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
//                            if needCheckOpenAccount {
//                                if YXUserManager.canTrade() {
//                                    excuteBlock()
//                                }else {
//                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXUserManager.notiUpdateResetRootView), object: nil, userInfo: ["index" : YXTabIndex.holding])
//                                }
//                            }else {
//                                excuteBlock()
//                            }
//
//                        })
//                    }
//
//                    let context = YXNavigatable(viewModel: YXLoginViewModel(callBack: callback, vc: currentVC))
//                    navigator.push(YXModulePaths.defaultLogin.url, context: context)
//                }
//            }
            
            
            switch parser.baseUrl {
            case YWNavtiveRouterConstant.GOTO_USER_LOGIN:
                if let market = parser.getParam(withKey: "market"),
                    let code = parser.getParam(withKey: "code") {
                    
                    let name = parser.getParam(withKey: "name")

                    let input = YWHomeViewModel()
               
//                    navigator.push(YWModulePaths.home, context: ["dataSource" : [input], "selectIndex" : 0])
                } else {
                    
                }
            default:
                print("未知")
            
        }
        
            return false
            
        }
        
        return false
    }
    
}
