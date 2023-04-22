//
//  AppDelegate+Category.swift
//  YWTigerkin
//
//  Created by odd on 4/10/23.
//

import Foundation

extension AppDelegate {
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
}
