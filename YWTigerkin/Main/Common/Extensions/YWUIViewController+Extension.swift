//
//  YWUIViewController+Extension.swift
//  YWTigerkin
//
//  Created by odd on 3/16/23.
//

import Foundation

extension UIViewController {
    
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
                    if #available(iOS 9.0, *) {
                        alertController.preferredAction = action
                    }
                }
            }
            present(alertController, animated: true, completion: nil)
            return alertController
        }
}
