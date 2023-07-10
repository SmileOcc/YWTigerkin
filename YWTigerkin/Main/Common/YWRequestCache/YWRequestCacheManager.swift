//
//  YWRequestCacheManager.swift
//  YWTigerkin
//
//  Created by odd on 7/9/23.
//

import UIKit
import SwiftlyCache

class YWRequestCacheManager: NSObject {

    @objc public static let shareInstance = YWRequestCacheManager()

    private var cacheManager: MemoryCache = MemoryCache<String>()
    
    static func saveCache(value:String, key:String) {
        YWRequestCacheManager.shareInstance.cacheManager.set(forKey: key, value: value)
    }
    
    func requestCaceh(key: String) -> String? {
        
        return nil
    }
}
