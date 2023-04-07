//
//  YWView+Extension.swift
//  YWTigerkin
//
//  Created by odd on 3/13/23.
//

import Foundation

extension UIView{
    
    public func viewController() -> UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
    
    // MARK : 坐标尺寸
     var origin:CGPoint {
         get {
             return self.frame.origin
         }
         set(newValue) {
             var rect = self.frame
             rect.origin = newValue
             self.frame = rect
         }
     }
     
     var size:CGSize {
         get {
             return self.frame.size
         }
         set(newValue) {
             var rect = self.frame
             rect.size = newValue
             self.frame = rect
         }
     }
     
     var left:CGFloat {
         get {
             return self.frame.origin.x
         }
         set(newValue) {
             var rect = self.frame
             rect.origin.x = newValue
             self.frame = rect
         }
     }
     
     var top:CGFloat {
         get {
             return self.frame.origin.y
         }
         set(newValue) {
             var rect = self.frame
             rect.origin.y = newValue
             self.frame = rect
         }
     }
     
     var right:CGFloat {
         get {
             return (self.frame.origin.x + self.frame.size.width)
         }
         set(newValue) {
             var rect = self.frame
             rect.origin.x = (newValue - self.frame.size.width)
             self.frame = rect
         }
     }
     
     var bottom:CGFloat {
         get {
             return (self.frame.origin.y + self.frame.size.height)
         }
         set(newValue) {
             var rect = self.frame
             rect.origin.y = (newValue - self.frame.size.height)
             self.frame = rect
         }
     }
    
    var width:CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    
    
    var height:CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    
    //MARK:-size
    
//    func width() ->CGFloat {
//            return self.frame.size.width
//    }
//
//    func height() ->CGFloat {
//            return self.frame.size.height
//    }
            
     // MARK: - 位移
     
     // 移动到指定中心点位置
     func moveToPoint(point:CGPoint) -> Void
     {
         var center = self.center
         center.x = point.x
         center.y = point.y
         self.center = center
     }
     
     // 缩放到指定大小
     func scaleToSize(scale:CGFloat) -> Void
     {
         var rect = self.frame
         rect.size.width *= scale
         rect.size.height *= scale
         self.frame = rect
     }
     
     // MARK: - 毛玻璃效果
     
     // 毛玻璃
     func effectViewWithAlpha(alpha:CGFloat) -> Void
     {
        let effect = UIBlurEffect.init(style: UIBlurEffect.Style.light)
         let effectView = UIVisualEffectView.init(effect: effect)
         effectView.frame = self.bounds
         effectView.alpha = alpha
         
         self.addSubview(effectView)
     }
     
     // MARK: - 边框属性
     
     // 圆角边框设置
    func layer(radius:CGFloat, borderWidth:CGFloat, borderColor:UIColor) -> Void
     {
         if (0.0 < radius)
         {
             self.layer.cornerRadius = radius
             self.layer.masksToBounds = true
             self.clipsToBounds = true
         }
         
         if (0.0 < borderWidth)
         {
            self.layer.borderColor = borderColor.cgColor
             self.layer.borderWidth = borderWidth
         }
     }
     
     // MARK: - 翻转
     
     // 旋转 旋转180度 M_PI
     func viewTransformWithRotation(rotation:CGFloat) -> Void
     {
        self.transform = CGAffineTransform(rotationAngle: rotation);
     }
     
     // 缩放
     func viewScaleWithSize(size:CGFloat) -> Void
     {
        self.transform = self.transform.scaledBy(x: size, y: size);
     }
     
     // 水平，或垂直翻转
     func viewFlip(isHorizontal:Bool) -> Void
     {
         if (isHorizontal)
         {
             // 水平
            self.transform = self.transform.scaledBy(x: -1.0, y: 1.0);
         }
         else
         {
             // 垂直
            self.transform = self.transform.scaledBy(x: 1.0, y: -1.0);
         }
     }
}
