//
//  YWCustomMathTool.swift
//  YWTigerkin
//
//  Created by odd on 3/28/23.
//

import UIKit

class YWCustomMathTool: NSObject {
    ///从高度集合里面找出最短的那一个
    static func shortestColumnIndex(_ heights: [CGFloat]) -> Int {
        var index = 0
        var shortesHeight = CGFloat(MAXFLOAT)
        for (idx, obj) in heights.enumerated() {
            if obj < shortesHeight {
                shortesHeight = obj
                index = idx
            }
        }
        return index
    }
    ///从高度集合里面找出最长的那一个
    static func longestColumnIndex(_ heights:[CGFloat]) -> Int {
        var index = 0
        var longesHeight:CGFloat = 0.0
        for (idx,obj) in heights.enumerated() {
            if obj > longesHeight {
                longesHeight = obj
                index = idx
            }
        }
        return index
    }
}
