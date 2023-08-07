//
//  YWUIViewController+Extension.swift
//  YWTigerkin
//
//  Created by odd on 3/16/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func current() -> UIViewController {
        let window = YWConstant.kKeyWindow()

        return UIViewController.getCurrentVC1(root: window?.rootViewController) ?? UIViewController()
    }
    
    public func current() -> UIViewController {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return UIViewController()
    }
    
    func getCurrentVC1() -> UIViewController {
        var result: UIViewController? = nil
        let window = YWConstant.kKeyWindow()
        if var keyWindow = window {
            
         
         // UIWindow.Level window三种等级 normal，alert，statusBar,可见normal才是我们真正要用到的，这段代码就是
            //排除其他两种level，找到所需的normalWindow
            if keyWindow.windowLevel != UIWindow.Level.normal{
                let windows = UIApplication.shared.windows
                for tmp in windows{
                    if tmp.windowLevel == UIWindow.Level.normal{
                        keyWindow = tmp
                        break
                    }
                }
            }
            
            
            
        result = UIViewController.getCurrentVC1(root: keyWindow.rootViewController)
        }
        
        return result ?? UIViewController()
    }


    static private func getCurrentVC1(root:UIViewController?) -> UIViewController?{
        var currentVC:UIViewController? = nil
        var rootVC = root
        
        while rootVC?.presentationController != nil {
            rootVC = rootVC?.presentedViewController
        }
        
        if let vc = rootVC as? UITabBarController{
            //UITabBarController.selectedViewController就是rootVC,而不是那个UITabBarController本身
            currentVC = getCurrentVC1(root: vc.selectedViewController)
        }else if let vc = rootVC as? UINavigationController{
            //UINavigationController.visibleViewController才是rootVC,而不是UINavigationController本身
            currentVC = getCurrentVC1(root: vc.visibleViewController)
        }else{
            //除过上面两种VC,比如UIViewController本身就是rootVC
            currentVC = rootVC
        }
        
        return currentVC
    }
    
    public func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    public func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    public func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @discardableResult public func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            var allButtons = buttonTitles ?? [String]()
            if allButtons.count == 0 {
                allButtons.append("确定")
            }
            
            for index in 0..<allButtons.count {
                let buttonTitle = allButtons[index]
                let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                    completion?(index)
                })
                alertController.addAction(action)
                
                if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                    alertController.preferredAction = action
                }
            }
            present(alertController, animated: true, completion: nil)
            return alertController
        }
}
