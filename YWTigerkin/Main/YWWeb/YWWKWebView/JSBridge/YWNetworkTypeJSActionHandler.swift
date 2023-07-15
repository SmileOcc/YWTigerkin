//
//  YWNetworkTypeJSActionHandler.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit

class YWNetworkTypeJSActionHandler: YWBaseJSActionHandler {
    func onNetworkTypeChange(dictionary: Dictionary<String, Any>) -> Void {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: String.Encoding.utf8),
           let successCallback = self.successCallback {
            YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: self.webview, data: jsonString, callback: successCallback)
        }
    }
}
