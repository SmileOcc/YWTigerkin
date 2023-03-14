//
//  YWColor+Extension.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import Foundation
import UIKit

///从十六进制字符串获取颜色，
///color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
func YWHexColor(hex:String,alpha:CGFloat = 1.0) -> UIColor {
    return UIColor.hexColor(hex, alpha)
}

func YWRgbColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
}

///返回根据当前显示模式的color
func AutoFitHexColor(lightHex:String, darkHex:String) -> UIColor {
    if #available(iOS 13.0, *){
        let color = UIColor.init{trainCollection -> UIColor in
            if trainCollection.userInterfaceStyle == UIUserInterfaceStyle.dark{
                return UIColor.hexColor(darkHex)
            }else {
                return UIColor.hexColor(lightHex)
            }
        }
        return color
    }else {
        return UIColor.hexColor(lightHex)
    }
}

///返回根据当前模式的color
func AutoFitColor(lightColor:UIColor, darkColor:UIColor) -> UIColor {
    if #available(iOS 13.0, *){
        let color = UIColor.init{trainCollection -> UIColor in
            if trainCollection.userInterfaceStyle == UIUserInterfaceStyle.dark{
                return darkColor
            }else {
                return lightColor
            }
        }
        return color
    }else {
        return lightColor
    }
}

extension UIColor {

    convenience init(r:UInt32 ,g:UInt32 , b:UInt32 , a:CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
//    static var random: UIColor {
//        let red = Int.random(in: 0...255)
//        let green = Int.random(in: 0...255)
//        let blue = Int.random(in: 0...255)
//        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
//    }
    
    //生成随机色
    class var random: UIColor {
        return UIColor(r: arc4random_uniform(256),g: arc4random_uniform(256),b: arc4random_uniform(256))
    }

    ///从十六进制字符串获取颜色，
    ///color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
    public class func hexColor(_ hexString:String) -> UIColor {
        return UIColor.hexColor(hexString, 1.0)
        
    }
    
    public class func hexColor(_ hexString:String, _ alpha:CGFloat) -> UIColor {
        
        //删除字符串中的空格
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)

        
        // String should be 6 or 8 characters
        if cString.count < 6 { return UIColor.clear}

        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") { cString = String(subString) }
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if cString.hasPrefix("#") { cString = String(subString) }

        if cString.count != 6 { return UIColor.clear }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func hexString() -> String{
        var color = self
        
        if color.cgColor.numberOfComponents < 4 {
            let components = color.cgColor.components
            color = UIColor(red:components![0], green: components![0], blue: components![0], alpha: components![1])
        }
        
        if color.cgColor.colorSpace?.model != CGColorSpaceModel.rgb{
            return "#FFFFFF"
        }
        
        return String(format: "#%02X%02X%02X",
                      (color.cgColor.components?[0])!*255.0,
                      (color.cgColor.components?[1])!*255.0,
                      (color.cgColor.components?[2])!*255.0)
    }
    
    //颜色值生成图片
    public class func createImage(colorString: String, size: CGSize) -> UIImage? {
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let co =  hexColor(colorString)
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(co.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}
