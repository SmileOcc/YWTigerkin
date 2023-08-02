//
//  YWAdvsEventsManager.swift
//  YWTigerkin
//
//  Created by odd on 3/24/23.
//

import UIKit

class YWAdvsEventsManager: NSObject {

    func advEventTarget(target:Any?, advEventModel:YWAdvsEventsModel) {
        
        if let root = UIApplication.shared.delegate as? AppDelegate {
            
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
                    navigator.pushPath(YWModulePaths.login.url, context: context, animated: true)
                }
            }
            
            if false {
                
            } else {//需要登录
                
                checkLogin { [weak self] in
                   //事件处理
                }
                
            }
            
        }
    }
}
