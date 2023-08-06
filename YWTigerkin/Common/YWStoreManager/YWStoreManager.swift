//
//  YWStoreManager.swift
//  YWTigerkin
//
//  Created by odd on 8/5/23.
//

import UIKit
import MMKV

class YWStoreManager: NSObject {

    static func store(_ value: Any, _ key: String) {
        
        if let str = value as? String {
            MMKV.default()?.set(str, forKey: key)
        } else if let str = value as? Int32 {
            MMKV.default()?.set(str, forKey: key)
        }
    }
    
    static func object(_ anyClass: AnyClass, _ key: String) -> Any? {
        MMKV.default()?.object(of: anyClass, forKey: key)
    }
    
    static func int32(_ key: String) -> Int32 {
        MMKV.default()?.int32(forKey:key) ?? 0
    }
    
    static func int64(_ key: String) -> Int64 {
        MMKV.default()?.int64(forKey:key) ?? 0
    }
}

