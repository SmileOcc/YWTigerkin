//
//  YWScreenTool.swift
//  YWTigerkin
//
//  Created by odd on 4/10/23.
//

import Foundation

enum SCREEN_SET {
    //垂直
    case set_port
    //水平
    case set_land
    //自动
    case set_auto
}


public struct YWScreenTool {
    func switchScreenOrientation(vc: UIViewController, mode: SCREEN_SET) {
        YWAppDelegate?.screen_set = mode
        if #available(iOS 16.0, *) {
            /// iOS 16以上需要通过scene来实现屏幕方向设置
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//            switch mode {
//            case .set_port:
//                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
//                break
//            case .set_land:
//                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
//                break
//            case .set_auto:
//                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .all))
//                break
//            }
//            vc.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            switch mode {
            case .set_port:
                /// 强制设置成竖屏
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                break
            case .set_land:
                /// 强制设置成横屏
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                break
            case .set_auto:
                /// 设置自动旋转
                UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
                break
            }
        }
    }
    
    static func isPortrait() -> Bool{
        
        // 获取当前手机物理状态的屏幕模式，看看是横屏还是竖屏.
        
        let interfaceOrientation = UIApplication.shared.statusBarOrientation
        
        if(interfaceOrientation == UIInterfaceOrientation.portrait)
            
        {
            
            //当前是在竖屏模式
            
            print("竖屏")
            return true
            
        }else{
            
            //当前是在横屏模式
            
            return false
        }
    }
    
    static func interfaceOrientation(isPortrait: Bool) {
        
        if isPortrait {
            
            YWAppDelegate?.screen_set = .set_port
            

            let value = UIInterfaceOrientation.portrait.rawValue

            UIDevice.current.setValue(value, forKey: "orientation")
            
        } else {
            
            YWAppDelegate?.screen_set = .set_land

            let value = UIInterfaceOrientation.landscapeLeft.rawValue

            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
}
