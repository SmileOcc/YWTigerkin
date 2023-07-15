//
//  YWGetJSActionHandler.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit
import WebKit

class YWGetJSActionHandler: YWBaseJSActionHandler {
    override func handlerAction(withWebview webview:WKWebView, actionEvent: String, paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        super.handlerAction(withWebview: webview, actionEvent: actionEvent, paramsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
        switch actionEvent {
        case GET_USER_INFO:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onGetUserInfo?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case GET_IMAGE_FROM_CAMERA_OR_ALBUM:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onGetImageFromCameraOrAlbum?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case GET_IMAGE_OR_FILE_FROM_CAMERA_OR_ALBUM_OR_FILEMANAGER:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onGetImageOrFileFromCameraOrAlbumOrFileManager?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case GET_NOTIFICATION_STATUS:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onGetNotificationStatus?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case GET_APP_CONNECT_ENVIRONMENT:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onGetAppConnectEnvironment?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        case GET_HTTP_SIGN:
            if let webview = webview as? YWWKWebView {
                webview.jsDelegate?.onGetHttpSign?(withParamsJsonValue: paramsJsonValue, successCallback: successCallback, errorCallback: errorCallback)
            }
        default:
            print("no matched get action")
            //log(.error, tag: kOther, content: "no matched get action")
        }
    }
}
