//
//  YWColor+Theme.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import Foundation

//适配黑暗模式
extension UIColor {
    //class 声明一个类属性
    
    class var theme_color: UIColor {
        return UIColor(r: 27, g: 221, b: 142)
    }
    
    class var themeText_color: UIColor {
        return UIColor(r: 27, g: 221, b: 142)
    }
    
    ///<Auto:统一的导航栏白色背景色 Light:#FFFFFF  dark:#1C1C1C
    class var a_whiteNavBg_color:UIColor {
        return AutoFitHexColor(lightHex: "#FFFFFF", darkHex: "#1C1C1C")
    }
    
    /**
     *Auto:统一的底部菜单栏白色背景色 Light:#FFFFFF  dark:#1C1C1C
     */
    class var a_whiteTabBarBg_color:UIColor {
        return AutoFitHexColor(lightHex: "#FFFFFF", darkHex: "#1C1C1C")
    }
    
    ///<Auto:白色背景色 Light:#FFFFFF  dark:#1C1C1C
    class var a_whiteBg_color:UIColor {
        return AutoFitHexColor(lightHex: "#FFFFFF", darkHex: "#1C1C1C")
    }
}
