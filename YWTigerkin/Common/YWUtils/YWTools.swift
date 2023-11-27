//
//  YWTools.swift
//  YWTigerkin
//
//  Created by odd on 7/8/23.
//

import Foundation

//
//func myMethod(anObj: Any) {
//    synchronized(anObj) {
//        // 在括号内 anObj 不会被其他线程改变
//    }
//}

func YWBaseCofig(_ key:String) -> String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            return ""
        }
        let infoDic = NSDictionary(contentsOfFile: path)
        let value = infoDic?["key"] as? String ?? ""
        return value
    }


func synchronized(_ lock: Any, closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
