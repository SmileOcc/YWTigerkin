//
//  YWCommandJSActionHandler.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit
import WebKit

class YWCommandJSActionHandler: YWBaseJSActionHandler {

    override func handlerAction(withWebview webview:WKWebView, actionEvent: String, paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        super.handlerAction(withWebview: webview, actionEvent: actionEvent, paramsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
        switch actionEvent {
        case COMMAND_SHARE:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandShare?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_CHECK_CLIENT_INSTALL_STATUS:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandCheckClientInstallStatus?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_LOGOUT_USER_ACCOUNT:
            //log(.info, tag: kOther, content: "COMMAND_LOGOUT_USER_ACCOUNT")
            print("")
        case COMMAND_CLOSE_WEBVIEW:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandCloseWebView?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_GO_BACK:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandGoBack?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_HIDE_TITLEBAR:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandHideTitlebar?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_SHOW_TITLEBAR:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandShowTitlebar?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_COPY_TO_PASTEBOARD:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandCopyToPasteboard?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_USER_LOGIN:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandUserLogin?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_BIND_MOBILE_PHONE:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandBindMobilePhone?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_OPEN_NOTIFICATION:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandOpenNotification?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_SET_TITLEBAR_BUTTON:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandSetTitlebarButton?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_SCREENSHOT_SHARE_SAVE:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandScreenshotShareSave?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
            
        case COMMAND_CONTACT_SERVICE:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandContactService?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_SAVE_PICTURE:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandSavePicture?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_TOKEN_FAILURE:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandTokenFailure?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_UPLOAD_ELK_LOG:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandUploadElkLog?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_ENABLE_PULL_REFRESH:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandEnablePullRefresh?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_REFRESH_USER_INFO:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandRefreshUserInfo?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_UPLOAD_APPSFLYER_EVENT:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandUploadAppsflyerEvent?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_BUY_IN_APP_PRODUCT:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandBuyInAppProductEvent?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_PRODUCT_CONSUME_RESULT:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandProductConsumeResult?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_SET_SCREEN_ORIENTATION:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandSetScreenOrientation?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_SHOW_FLOATINGVIEW:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandShowFloatingView?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_DISMISS_FLOATINGVIEW:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandDismissFloatingView?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_REFRESH:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandRefreshData?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case COMMAND_APP_OPEN_URL:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onCommandAppOpenUrl?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        default:
            print("no matched command action")
            //log(.error, tag: kOther, content: "no matched command action")
        }
    }
}
