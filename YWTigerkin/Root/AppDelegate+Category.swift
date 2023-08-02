//
//  AppDelegate+Category.swift
//  YWTigerkin
//
//  Created by odd on 4/10/23.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
//import AppTrackingTransparency

extension AppDelegate {
    
    func yw_Application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        
        cofigureKeyboardManager()
        initPushConfig(application)
        initNotifications()
        
        //调试分享
        YWShareSDKHelper.instance.isTestAllPlatform = true
        // 多语言读取文件
        YWLanguageUtility.initUserLanguage()
        configureApplePay()
        configureButtonRepeat()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if screen_set == .set_port {
            return .portrait
        }
        if screen_set == .set_land {
            return [.landscapeRight,.landscapeLeft]
        }
        if screen_set == .set_auto {
            return [.portrait,.landscapeRight,.landscapeLeft]
        }
        return .all
    }
    
    func configureApplePay() {
        
    }
    
    func configureButtonRepeat() {
        UIButton.initializeMethod()
    }
    
    func cofigureKeyboardManager() {
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false

    }
}


private extension AppDelegate {
    func initPushConfig(_ application: UIApplication) {
        // 初始化推送配置
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {

                center.requestAuthorization(options: [.sound, .badge, .alert], completionHandler: { (granted, error) in

                    DispatchQueue.main.async {
                        if granted {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                      
                        //首页广告待通知授权完成后才弹
                        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: YWPopManager.kNotificationName), object: nil, userInfo:nil)
                        
                        if #available(iOS 14.0, *) {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//                                ATTrackingManager.requestTrackingAuthorization { status in
//                                }
//                            })
                        }
                    }
                })
            } else {
                if #available(iOS 14.0, *) {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//                        ATTrackingManager.requestTrackingAuthorization { status in
//
//                        }
//                    })
                }
            }
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }

    
    //MARK: resetRootView、tab跳转方法
    func initNotifications() {
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: YWUserManager.notiUpdateResetRootView))
            .take(until: self.rx.deallocated)
            .subscribe(onNext: { [weak self] (notification) in
                guard let `self` = self else { return }
                
                
                // 这里使用重新初始化的原因是在于，如果是切换语言时，需要让页面重新初始化，才会成功的切换语言
                self.initRootViewController()
            
                
                if let userInfo = notification.userInfo {
                    self.resetRootView(with: userInfo)
                }
                
                
                
                if let object = notification.object as? Dictionary<String, Any> {
                    
                }
            })
        
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: YWUserManager.notiLogin))
            .take(until: self.rx.deallocated)
            .subscribe(onNext: { [weak self] (ntf) in
                guard let `self` = self else { return }

//                self.updateTabBar()
//                self.initRootViewController()

            })

        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: YWUserManager.notiLoginOut))
            .take(until: self.rx.deallocated)
            .subscribe(onNext: { [weak self] (ntf) in
                guard let `self` = self else { return }

//                self.updateTabBar()
                self.initRootViewController()

            })
        
//        _ = NotificationCenter.default.rx
//            .notification(Notification.Name(rawValue: YWUserManager.notiUpdateUserInfo))
//            .take(until: self.rx.deallocated)
//            .subscribe(onNext: { [weak self] (ntf) in
//                guard let `self` = self else { return }
//
////                self.updateTabBar()
//                self.initRootViewController()
//
//            })
        
        
    }
    
    private func resetRootView(with userInfo: [AnyHashable : Any]) {
        

        guard let tab = self.tab else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            if let index = userInfo["index"] as? YWTabIndex {
                tab.selectedIndex = index.rawValue //切换tabbar
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                    tab.selectedIndex = index.rawValue
                })
            } else {
                tab.selectedIndex = 0
            }
        })
    }
    
    func updateTabBar() {
        let tabbarViewController = self.tab

        let homeIndex = YWTabIndex.home.rawValue
        tabbarViewController?.selectedIndex =  homeIndex

    }
}
