//
//  YWThemesColors.swift
//  YWTigerkin
//
//  Created by odd on 3/24/23.
//

import UIKit

class YWThemesColors: NSObject {
    
    class var col_themeColor:UIColor {
        return YWThemesColors.col_8A2BE2.withAlphaComponent(0.7)
    }
    
    class var col_themeColor_03:UIColor {
        return YWThemesColors.col_8A2BE2.withAlphaComponent(0.3)

    }
    
    class func col_themeImage(_ img: UIImage?) -> UIImage {
        return img?.tint(color: YWThemesColors.col_themeColor) ?? UIImage()
    }
    
    class var col_blackColor:UIColor {
        return AutoFitHexColor(lightHex: "#000000", darkHex: "#000000")

    }
    
    class var col_whiteColor:UIColor {
        return AutoFitHexColor(lightHex: "#FFFFFF", darkHex: "#FFFFFF")

    }
    
    class var col_blackWhiteColor:UIColor {
        return AutoFitHexColor(lightHex: "#FFFFFF", darkHex: "#000000")

    }
    
    //紫色
    class var col_A020F0:UIColor {
        return AutoFitHexColor(lightHex: "#A020F0", darkHex: "#A020F0")
    }
    
    //紫罗蓝色
    class var col_8A2BE2:UIColor {
        return AutoFitHexColor(lightHex: "#8A2BE2", darkHex: "#8A2BE2")
    }
    
    //淡紫色
    class var col_DA70D6:UIColor {
        return AutoFitHexColor(lightHex: "#DA70D6", darkHex: "#DA70D6")
    }
    
    //浅灰蓝色
    class var col_B0E0E6:UIColor {
        return AutoFitHexColor(lightHex: "#B0E0E6", darkHex: "#B0E0E6")
    }
    
    //石板蓝色
    class var col_6A5ACD:UIColor {
        return AutoFitHexColor(lightHex: "#6A5ACD", darkHex: "#6A5ACD")
    }
    
    //天蓝色
    class var col_87CEEB:UIColor {
        return AutoFitHexColor(lightHex: "#87CEEB", darkHex: "#87CEEB")
    }
    
    //MARK: - 主字体色
    class var col_333333:UIColor {
        return AutoFitHexColor(lightHex: "#333333", darkHex: "#333333")
    }
    
    class var col_f6f6f6:UIColor {
        return AutoFitHexColor(lightHex: "#f6f6f6", darkHex: "#f6f6f6")
    }
    
    class var col_999999:UIColor {
        return AutoFitHexColor(lightHex: "#999999", darkHex: "#1C1C1C")
    }
    
    class var col_0D0D0D:UIColor {
        return AutoFitHexColor(lightHex: "#0D0D0D", darkHex: "#0D0D0D")
    }
    
    class var col_F5F5F5:UIColor {
        return AutoFitHexColor(lightHex: "#F5F5F5", darkHex: "#F5F5F5")
    }
    
    class var col_F7F7F7:UIColor {
        return AutoFitHexColor(lightHex: "#F7F7F7", darkHex: "#F7F7F7")
    }
    
    class var col_B2B2B2:UIColor {
        return AutoFitHexColor(lightHex: "#B2B2B2", darkHex: "#B2B2B2")
    }
    
    class var col_B3B3B3:UIColor {
        return AutoFitHexColor(lightHex: "#B3B3B3", darkHex: "#B3B3B3")
    }
    
    //MARK: - 线条
    class var col_line:UIColor {
        return AutoFitHexColor(lightHex: "#8A2BE2", darkHex: "#8A2BE2")
    }
    
    class var col_CCCCCC:UIColor {
        return AutoFitHexColor(lightHex: "#CCCCCC", darkHex: "#CCCCCC")
    }
    //MARK: - 错误
    class var col_error:UIColor {
        return AutoFitHexColor(lightHex: "#DA70D6", darkHex: "#DA70D6")
    }
    
}
