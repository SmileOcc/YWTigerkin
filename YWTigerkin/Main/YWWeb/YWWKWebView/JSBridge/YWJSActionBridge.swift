//
//  YWJSActionBridge.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit
import WebKit

class YWJSActionBridge: NSObject, WKScriptMessageHandler {
    @objc var watchActivityJSActionHandler:YWWatchActivityJSActionHandler
    @objc var networkTypeJSActionHandler:YWNetworkTypeJSActionHandler
    @objc var gotoNativeManager: YWGotoNativeProtocol?
    
    @objc public init(webView: WKWebView, gotoNativeManager: YWGotoNativeProtocol?) {
        self.watchActivityJSActionHandler = YWWatchActivityJSActionHandler(webView: webView)
        self.networkTypeJSActionHandler = YWNetworkTypeJSActionHandler(webView: webView)
        self.gotoNativeManager = gotoNativeManager
        super.init()
    }
    
    /// 接受Webview中JavaScript的消息代理方法
    ///
    /// - Parameters:
    ///   - userContentController: userContentController description
    ///   - message: message description
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "JSActionBridge" {//统一的交互总返回
            var dic : Dictionary<String, Any>?
            if let string = message.body as? String {
                dic = YWJSActionUtil.convertToDictionary(text: string)
            } else if let dictionary = message.body as? Dictionary<String, Any> {
                dic = dictionary
            }
            
            if dic != nil {
                if let method = dic?["method"] as? String, method == "handlerAction" {//定义的事件类型
                    let data = dic?["data"] as? Dictionary<String, Any>
                    if let actionEvent = data?["actionEvent"] as? String,
                        let webView = message.webView {
                        let jsActionHandler = getJSActionHandler(withActionEvent: actionEvent, webView: webView)
                        //h5 带来的数据
                        let paramsJsonValue = data?["paramsJsonValue"] as? Dictionary<String, Any>
                        //h5 js回调的方法(这些方法 需要h5的windows上注册）
                        let successCallback = data?["successCallback"] as? String
                        //h5 js错误方法
                        let errorCallback = data?["errorCallback"] as? String
                        jsActionHandler?.handlerAction(withWebview: webView, actionEvent: actionEvent, paramsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
                    }
                }
            }
        }
    }
    
    
    /// 获取对应actionEvent的Handler
    ///
    /// - Parameter actionEvent: actionEvent字符串
    /// - Returns: 对应的JSActionHandler，目前支持YXGotoNativeJSActionHandler、YXGetJSActionHandler和YXCommandJSActionHandler三种
    func getJSActionHandler(withActionEvent actionEvent: String, webView: WKWebView) -> YWBaseJSActionHandler? {
        var jsActionHandler : YWBaseJSActionHandler?
        
        if actionEvent.hasPrefix(GOTO_NATIVE_MOUDLE) {
            jsActionHandler = YWGotoNativeJSActionHandler(webView: webView, gotoNativeManager: self.gotoNativeManager)
            
        } else if actionEvent.hasPrefix(JS_ACTION_GET_PREFIX) {
            jsActionHandler = YWGetJSActionHandler(webView: webView)
            
        } else if actionEvent.hasPrefix(JS_ACTION_COMMAND_PREFIX) {
            
            if actionEvent == COMMAND_WATCH_ACTVITY_STATUS {
                jsActionHandler = self.watchActivityJSActionHandler
            } else if actionEvent == COMMAND_WATCH_NETWORK {
                jsActionHandler = self.networkTypeJSActionHandler
            } else {
                jsActionHandler = YWCommandJSActionHandler(webView: webView)
            }
        }
        
        return jsActionHandler
    }
    
    @objc public func onActivityStatusChange(isVisible: Bool) {
        self.watchActivityJSActionHandler.onActivityStatusChange(isVisible: isVisible)
    }
    
    @objc public func onNetworkTypeChange(dictionary: Dictionary<String, Any>) {
        self.networkTypeJSActionHandler.onNetworkTypeChange(dictionary: dictionary)
    }
    
    @objc public func onAppDidBecomeActive() {
        self.watchActivityJSActionHandler.onAppDidBecomeActive()
    }
}
