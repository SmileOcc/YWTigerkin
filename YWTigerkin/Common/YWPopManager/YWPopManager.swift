//
//  YWPopManager.swift
//  YWTigerkin
//
//  Created by odd on 8/5/23.
//

import UIKit

class YWPopManager: NSObject {
    public static let YWAdvertiseDidShowCache =  "YWAdvertiseDidShowCache"// 闪屏广告是否展示
    @objc static  let kNotificationName = "YWPopDidShowHighPopNotification"
    public static let kYXFristInstallCache =  "kYXFristInstallCache"// 是否第一次
    public static let kYXPopDayCache =  "kYXPopDayCache"// 缓存展示时日期
    
    @objc static let shared = YWPopManager()

    func checkPop(vc: UIViewController) {
        
    }
    
    //检查Pop的弹窗状态
    @objc func checkPopShowStatus(with showPage:Int,vc:UIViewController) {
        let showSplash = MMKV.default()?.bool(forKey: YWPopManager.YWAdvertiseDidShowCache)
        let fristInstall = isFristInstall()
        if showSplash == true || fristInstall == true || YWUpdateManager.shared.finishedUpdatePop == false {
            return
        }
    }
    
    func isFristInstall() -> Bool {
       let statu = MMKV.default()?.bool(forKey: YWPopManager.kYXFristInstallCache) ?? false
       return statu
        
    }
    
    func didInstalled() {
        MMKV.default()?.set(false, forKey: YWPopManager.kYXFristInstallCache)
    }
}
