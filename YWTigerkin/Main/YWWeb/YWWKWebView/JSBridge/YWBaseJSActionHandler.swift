//
//  YWBaseJSActionHandler.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit
import WebKit

class YWBaseJSActionHandler: NSObject {

    var webview: WKWebView
    var successCallback : String?
    var errorCallback : String?
    
    init(webView: WKWebView) {
        self.webview = webView
        super.init()
    }
    
    func handlerAction(withWebview webview:WKWebView, actionEvent : String, paramsJsonValue : Dictionary<String, Any>?, successCallback : String?, errorCallback : String?) -> Void {
        self.successCallback = successCallback
        self.errorCallback = errorCallback
    }
}
