//
//  YWNSObject+Extension.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import Foundation

extension NSObject {
    //获取一个类的所有属性
    func getAllPropertys(clsName: Any?) -> [String] {
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(object_getClass(clsName), count)
        let countInt = Int(count[0])
        for i in 0..<countInt {
            if let temp = buff?[i] {
                let cname = property_getName(temp)
                let proper = String(cString: cname)
                result.append(proper)
            }
        }
        return result
    }
    //获取一个类的成员变量
    func getAllIvarList(clsName: Any?) -> [String] {
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyIvarList(object_getClass(clsName), count)
        let countInt = Int(count[0])
        for i in 0..<countInt {
            if let temp = buff?[i],let cname = ivar_getName(temp) {
                let proper = String(cString: cname)
                result.append(proper)
            }
        }
        return result
    }

}
