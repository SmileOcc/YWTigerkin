//
//  YWImage+Extension.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import Foundation
import UIKit

extension UIImage
{
    
    //添加着色方法
    func tint(color: UIColor) -> UIImage {
        if #available(iOS 13.0, *) {
            return self.withTintColor(color)
        }
        return self.tint(color: color, blendMode: .destinationIn)
    }
    
    //添加着色方法
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
    //颜色值生成图片
    public class func imgColor(_ color: UIColor, _ size: CGSize) -> UIImage {
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let co =  color
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(co.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image ?? UIImage()
    }
}
