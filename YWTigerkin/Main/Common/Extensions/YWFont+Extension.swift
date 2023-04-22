//
//  YWFont+Extension.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import Foundation
import UIKit

///< 适配，屏幕宽高适配比例， iPhone6 模板设计
let kAutoSizeScale_X = ((KSCREEN_HEIGHT == 667.0) ? 1.0 : (KSCREEN_WIDTH / 375.0))
let kAutoSizeScale_Y = ((KSCREEN_HEIGHT == 667.0) ? 1.0 : (KSCREEN_HEIGHT / 667.0))

/**
 *floor 向下取整
 *ceil  向上取整
 ***/
///< 横向自适应拉伸
func kAutoConvertWithScreenW_Value(_ value:CGFloat) -> CGFloat {
    return floor(value * kAutoSizeScale_X)
}
///< 纵向向自适应拉伸
func kAutoConvertWithScreenH_Value(_ value:CGFloat) -> CGFloat {
    return floor(value * kAutoSizeScale_Y)
}

extension UIFont {

    class func mediumFont(_ size:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    class func regularFont(_ size:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    class func boldFont(_ size:CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    ///< 自适配 字体大小
   class func kAutoSystemFont(_ size:CGFloat) -> UIFont {
        return .systemFont(ofSize: kAutoConvertWithScreenW_Value(size))
    }
    
    ///< 自适配 加粗 字体大小
    class func kAutoBoldFont(_ size:CGFloat) -> UIFont {
        return .boldSystemFont(ofSize: kAutoConvertWithScreenW_Value(size))
    }
    
    ///< 自适配 name 字体大小
    class func kAutoNameFont(_ name:String, _ size:CGFloat) -> UIFont {
        return UIFont(name: name, size: kAutoConvertWithScreenW_Value(size)) ?? kAutoSystemFont(size)
    }
    
    ///< 自适应 12号字体
    class var autoFont_12:UIFont{
        get{
            return kAutoSystemFont(12.0)
        }
    }
    ///< 自适应 14号字体
    class var autoFont_14:UIFont{
        get{
            return kAutoSystemFont(14.0)
        }
    }
    ///< 自适应 16号字体
    class var autoFont_16:UIFont{
        get{
            return kAutoSystemFont(16.0)
        }
    }
    ///< 自适应 18号字体
    class var autoFont_18:UIFont{
        get{
            return kAutoSystemFont(18.0)
        }
    }
    ///< 自适应 20号字体
    class var autoFont_20:UIFont{
        get{
            return kAutoSystemFont(20.0)
        }
    }
}
