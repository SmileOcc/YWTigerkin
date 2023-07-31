//
//  YWLoginCtrl+Exten.swift
//  YWTigerkin
//
//  Created by odd on 7/28/23.
//

import Foundation

extension UIViewController {
    
    // 注册登录成功返回处理
    func loginSuccessBack(_ soureVc: UIViewController?, loginCallBack: (([String: Any])->Void)?) {
        
        if true {
            //暂时统一用模态进入登录
            self.dismiss(animated: true)
            return;
//        if YWLaunchGuideManager.isGuideToLogin() == false {//不是引导页进来
//            if YWUserManager.isShowLoginRegister() {//灰度登录注册
//                YWUserManager.registerLoginInitRootViewControler()
//                return
//            }
            
            if let vc = soureVc {//有来源，返回来源 (如果用push去登录的）
                if self.navigationController?.viewControllers.contains(vc) ?? false {
                    self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
            

            // 异常返回处理
            if let root = UIApplication.shared.delegate as? AppDelegate {
                if root.window?.rootViewController is UITabBarController {
                    self.navigationController?.popToRootViewController(animated: true)
                    return
                }
            }
            // 不是tab,重置tab
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YWUserManager.notiUpdateResetRootView), object: nil, userInfo: ["index" : YWTabIndex.market])
            

        } else { // 引导页进来
//            YWLaunchGuideManager.setGuideToLogin(withFlag: false)   //关闭从引导页到登录的标记
//            if YWUserManager.isShowLoginRegister() {//灰度登录注册
//                YWUserManager.registerLoginInitRootViewControler()
//                return
//            }
//
//            if loginCallBack == nil { //防止异常处理，没有传入回调 （引导页没给回调的话）
//
//                // 异常返回处理
//                if let root = UIApplication.shared.delegate as? YXAppDelegate {
//                    if root.window?.rootViewController is UITabBarController {
//                        self.navigationController?.popToRootViewController(animated: true)
//                        return
//                    }
//                }
//
//                // 不是tab,重置tab
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXUserManager.notiUpdateResetRootView), object: nil, userInfo: ["index" : YXTabIndex.market])
//            }
        }
    }
}
