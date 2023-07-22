//
//  AppDelegate+Category.swift
//  YWTigerkin
//
//  Created by odd on 4/10/23.
//

import Foundation
import UIKit

extension AppDelegate {
    
    func yw_Application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        
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
}
