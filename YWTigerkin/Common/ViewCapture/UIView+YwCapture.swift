//
//  UIView+YwCapture.swift
//  YWTigerkin
//
//  Created by odd on 7/15/23.
//

import Foundation
import WebKit

private var SwViewCaptureKey_IsCapturing: String = "SwViewCapture_AssoKey_isCapturing"

public extension UIView {
    
    @objc func swSetFrame(_ frame: CGRect) {
        // Do nothing, use for swizzling
    }
    
    var isCapturing:Bool! {
        get {
            let num = objc_getAssociatedObject(self, &SwViewCaptureKey_IsCapturing)
            if num == nil {
                return false
            }
            
            if let numObj = num as? NSNumber {
                return numObj.boolValue
            }else {
                return false
            }
        }
        set(newValue) {
            let num = NSNumber(value: newValue as Bool)
            objc_setAssociatedObject(self, &SwViewCaptureKey_IsCapturing, num, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Ref: chromium source - snapshot_manager, fix wkwebview screenshot bug.
    // https://chromium.googlesource.com/chromium/src.git/+/46.0.2478.0/ios/chrome/browser/snapshots/snapshot_manager.mm
    func swContainsWKWebView() -> Bool {
        if self.isKind(of: WKWebView.self) {
            return true
        }
        for subView in self.subviews {
            if (subView.swContainsWKWebView()) {
                return true
            }
        }
        return false
    }
    
    func swCapture(_ completionHandler: (_ capturedImage: UIImage?) -> Void) {
        
        self.isCapturing = true
        
        let bounds = self.bounds
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: -self.frame.origin.x, y: -self.frame.origin.y);
        
        if (swContainsWKWebView()) {
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        }else{
            self.layer.render(in: context!)
        }
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        context?.restoreGState();
        UIGraphicsEndImageContext()
        
        self.isCapturing = false
        
        completionHandler(capturedImage)
    }
    // 圆角
    //addCornerRadius(10, corners: [.topLeft, .bottomRight])
    func addCornerRadius(_ radius: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
//    func () {
//        view.layer.cornerRadius = 11.5
//        //左上、右上圆角
//        view.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.layerMinXMinYCorner.rawValue | CACornerMask.layerMaxXMinYCorner.rawValue)
//        //全部圆角
//        view.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.layerMinXMinYCorner.rawValue | CACornerMask.layerMinXMaxYCorner.rawValue | CACornerMask.layerMaxXMinYCorner.rawValue | CACornerMask.layerMaxXMaxYCorner.rawValue)
//
//    }
}

