//
//  YWNotification+Extension.swift
//  YWTigerkin
//
//  Created by odd on 7/2/23.
//

import Foundation

extension Notification {
    
    func keyBoardHeight() -> CGFloat {
        if let userInfo = self.userInfo {
            if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let size = value.cgRectValue.size
                return UIInterfaceOrientation.portrait.isLandscape ? size.width : size.height
            }
        }
        return 0
    }
    
}
