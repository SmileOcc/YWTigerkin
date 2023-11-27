//
//  YYTextAsyncLayer+Extension.swift
//  YWTigerkin
//
//  Created by odd on 11/11/23.
//

import Foundation

//_displayAsync
extension YYTextAsyncLayer {
    
    //适配ios17
    @objc private func swizzled_displayAsync(async:Bool) {
        if self.bounds.size.width <= 0 || self.bounds.size.height <= 0 {
            return
        }
        self.swizzled_displayAsync(async: async)
    }

    class func swizzledDisplayAsync() {
        let originalSelctor = NSSelectorFromString("_displayAsync:")
        //let originalSelctor = #selector(_displayAsync(async:))
        let swizzledSelector = #selector(swizzled_displayAsync(async:))
        swizzleMethod(for: self, originalSelector: originalSelctor, swizzledSelector: swizzledSelector)
    }

    private class func swizzleMethod(for aClass: AnyClass, originalSelector: Selector,swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(aClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)
        let didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        if didAddMethod {
            class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}
