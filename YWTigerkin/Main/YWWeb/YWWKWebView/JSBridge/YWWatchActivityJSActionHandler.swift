//
//  YWWatchActivityJSActionHandler.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit

class YWWatchActivityJSActionHandler: YWBaseJSActionHandler {
    func onActivityStatusChange(isVisible: Bool) -> Void {
        if isVisible {
            let data = ["status" : "visible"]
            if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8),
                let successCallback = self.successCallback {
                YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: self.webview, data: jsonString, callback: successCallback)
            }
        } else {
            let data = ["status" : "invisible"]
            if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8),
                let successCallback = self.successCallback {
                YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: self.webview, data: jsonString, callback: successCallback)
            }
        }
    }
    
    func onAppDidBecomeActive() -> Void {
        let data = ["status" : "appDidBecomActive"]
        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8),
            let successCallback = self.successCallback {
            YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: self.webview, data: jsonString, callback: successCallback)
        }
    }
}
