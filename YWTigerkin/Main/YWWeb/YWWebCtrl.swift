//
//  YWWebCtrl.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

import MobileCoreServices
import MessageUI
import AVFoundation //相机权限
import Photos //照片 权限

class YWWebCtrl: YWBaseViewController, HUDViewModelBased{
    
    var viewModel: YWWebViewModel!
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var webView: YWWKWebView?

    var progressView: UIProgressView?
    
    let progressViewHeight: CGFloat = 0.5
    
    var bridge: (YWJSActionBridge & WKScriptMessageHandler)?
    
    lazy var noDataView : UIView = {
        return UIView()
    }()
    
    var refreshHeader: YWRefreshHeader?

    var startedNavigation: Bool = false

    var chooseImageOrFileSuccessCallback: String?

    var chooseImageOrFileErrorCallback: String?
    
    var fileMode: Bool?

    deinit {
        print("deinit YXWebViewController")
        self.unregisterJavaScriptInterface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bridge?.onActivityStatusChange(isVisible: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bridge?.onActivityStatusChange(isVisible: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()

    }
    
    func initUI() {
        self.bindHUD()
        
        self.setupNavigationBar()
        
        self.changeWKWebViewUserAgent()
    }
    
    
    fileprivate func registerJavaScriptInterface() {
        if let webView = self.webView {
            self.bridge = YWJSActionBridge(webView: webView, gotoNativeManager: YWGoToNativeManager.shared)
            if let bridge = self.bridge {// html注册的一个总方法入口：里面包含对应事件回调的js返回，事件类型
                webView.configuration.userContentController.add(bridge, name: "JSActionBridge")
            }
        }
    }

    fileprivate func unregisterJavaScriptInterface() {
        if let webView = self.webView {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: "JSActionBridge")
        }
        self.bridge = nil
    }
    
    func setupNavigationBar() {
        
    }

    /**
     修改WKWebView的UserAgent
     先通过一个临时的YXWKWebView执行JS脚本，得到当前的userAgent
     然后设置userAgent后，再加载最终的YXWKWebView
     */
    fileprivate func changeWKWebViewUserAgent() {
        self.webView = YWWKWebView(frame: CGRect.zero)
        
        self.webView?.evaluateJavaScript("navigator.userAgent", completionHandler: { [weak self] result, error in
            guard let strongSelf = self else { return }
            
            var userAgent = result as? String
            if userAgent?.contains(" appVersion") ?? false {
                // 如果包含这个字符串，则认为已经添加过，则擦除后面的再重新设置一次
                let array = userAgent?.components(separatedBy: " appVersion")
                if (array?.count ?? 0) > 0 {
                    userAgent = array?[0]
                }
            }
            let infoStr = strongSelf.getDeviceInfoStr()
            let newUserAgent = "\(userAgent ?? "")\(infoStr)"
            let dictionary = [
                "UserAgent" : newUserAgent
            ]

            UserDefaults.standard.register(defaults: dictionary)

            DispatchQueue.main.async(execute: { [weak self] in
                guard let strongSelf = self else { return }
                
                // 重新初始化WKWebView
                strongSelf.webViewWillLoadRequest()
                // 1.重新注册JS Interface
                strongSelf.unregisterJavaScriptInterface()
                strongSelf.addRealWebView()
                // 2.重新注册JS Interface
                strongSelf.registerJavaScriptInterface()
                strongSelf.webViewLoadRequest()
                strongSelf.webViewDidLoadRequest()
            })
        })
    }
    
    func addRealWebView() {
        setupWebView()

        self.progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: YWConstant.screenWidth, height: self.progressViewHeight))
        
        if let progressView = self.progressView  {
            progressView.progressTintColor = UIColor.random
            progressView.progress = 0.05
            self.view.addSubview(progressView)
            progressView.trackTintColor = UIColor.random
            
            // 设置progressView的高度，因为系统的UIProgressView的高度是固定的。因此这里采用transform的方式进行设置
            let transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 0.25)
            progressView.transform = transform
        }

        self.webView?.rx.observe(Double.self, "estimatedProgress").subscribe(onNext: { [weak self] (estimatedProgress) in
            guard let strongSelf = self else { return }
            
            if let progressView = strongSelf.progressView {
                let animated: Bool = (strongSelf.webView?.estimatedProgress ?? 0.0) > Double(progressView.progress)
                progressView.setProgress(Float(strongSelf.webView?.estimatedProgress ?? 0.0), animated: animated)
                
                // Once complete, fade out UIProgressView
                if (strongSelf.webView?.estimatedProgress ?? 0.0) >= 1.0 {
                    UIView.animate(withDuration: 0.3, delay: 0.8, options: .curveEaseOut, animations: {
                        progressView.alpha = 0.0
                    }) { finished in
                        progressView.setProgress(0.0, animated: false)
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        //监听 title ，并设置
        self.webView?.rx.observe(String.self, "title").subscribe(onNext: { [weak self] (title) in
            guard let strongSelf = self else { return }
            
            strongSelf.title = strongSelf.webView?.title ?? ""
            //标题颜色
//            if !(strongSelf.viewModel.webTitle?.isEmpty ?? true) {
//                strongSelf.titleView?.title = strongSelf.viewModel.webTitle
//            } else {
//                strongSelf.titleView?.title = (!(strongSelf.webView?.title?.isEmpty ?? true)) ? strongSelf.webView?.title : ""
//            }
        }).disposed(by: disposeBag)
    }

    func setupWebView() {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.allowsInlineMediaPlayback = true

        
        self.webView = YWWKWebView(frame: CGRect(x: 0, y: 0, width: YWConstant.screenWidth, height: YWConstant.screenHeight - YWConstant.navBarHeight), configuration: config)
        if let webView = self.webView {
            view.addSubview(webView)
        }
//        self.viewModel.titleBarVisibleSubject.asObservable().subscribe(onNext: { [weak self] (value) in
//            guard let `self` = self else { return }
//
//            self.webView?.frame = self.webViewFrame()
//        }).disposed(by: disposeBag)
        
//        if let appDelegate = YWConstant.sharedAppDelegate as? AppDelegate {
//            appDelegate.rx.observe(Bool.self, "rotateScreen").subscribe(onNext: { [weak self] (rotateScreen) in
//                guard let `self` = self else { return }
//
////                if rotateScreen ?? false {
////                    UIApplication.shared.setStatusBarHidden(false, with: .fade)
////                }
//
////                self.progressView?.frame = self.progressViewFrame()
////                self.webView?.frame = self.webViewFrame()
//
//            }).disposed(by: disposeBag)
//        }
        
//        if viewModel.titleBarVisible {
//            self.webView = YXWKWebView(frame: CGRect(x: 0, y: YWConstant.navBarHeight(), width: YWConstant.screenWidth, height: YWConstant.screenHeight - YWConstant.navBarHeight()), configuration: config)
//            if let webView = self.webView {
//                view.addSubview(webView)
//            }
//        } else {
//            self.webView = YXWKWebView(frame: CGRect(x: 0, y: YWConstant.statusBarHeight(), width: YWConstant.screenWidth, height: YWConstant.screenHeight - YWConstant.statusBarHeight()), configuration: config)
//            if let webView = self.webView {
//                view.addSubview(webView)
//            }
//        }

//        self.webView?.backgroundColor = QMUITheme().foregroundColor()
//        self.webView?.scrollView.backgroundColor = QMUITheme().foregroundColor()
        self.webView?.allowsBackForwardNavigationGestures = false
        ///黑色皮肤,webview会闪烁
//        if YWThemeTool.isDarkMode() {
//            self.webView?.isOpaque = false
//        }
        self.webView?.navigationDelegate = self
        self.webView?.uiDelegate = self
        self.webView?.jsDelegate = self

        if #available(iOS 11.0, *) {
            self.webView?.scrollView.contentInsetAdjustmentBehavior = .never
            self.webView?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            if let contentInset = self.webView?.scrollView.contentInset {
                self.webView?.scrollView.scrollIndicatorInsets = contentInset
            }
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        self.refreshHeader = YWRefreshHeader.init(refreshingBlock: { [weak self] in
            self?.refreshWebview()
        })
        
        self.webView?.scrollView.mj_header = self.refreshHeader
    }
    
    func updateUserAgent() {
        self.webView?.evaluateJavaScript("navigator.userAgent", completionHandler: { [weak self] result, error in
            guard let strongSelf = self else { return }

            var userAgent = result as? String
            if userAgent?.contains(" appVersion") ?? false {
                // 如果包含这个字符串，则认为已经添加过，则擦除后面的再重新设置一次
                let array = userAgent?.components(separatedBy: " appVersion")
                if (array?.count ?? 0) > 0 {
                    userAgent = array?[0]
                }
            }
            let infoStr = strongSelf.getDeviceInfoStr()
            let newUserAgent = "\(userAgent ?? "")\(infoStr)"
            let dictionary = [
                "UserAgent" : newUserAgent
            ]

            UserDefaults.standard.register(defaults: dictionary)
            strongSelf.webView?.customUserAgent = newUserAgent
            strongSelf.webView?.reload()
        })
    }
    
    /**
     获取设备信息

     @return 设备信息
     */
    fileprivate func getDeviceInfoStr() -> String {
        let appVersion = " appVersion/\(YWConstant.appVersion ?? "")"
        let softwareVersion = "softwareVersion/\(YWConstant.appBuild ?? "")"
        let platform = "platform/\("ywtk-iOS")"
        let model = "model/\(YWConstant.deviceModel)"
        let uuid = "uuid/\(YWConstant.deviceUUID)"
        let appId = "appId/\(YWConstant.bundleId ?? "")"


        return "\(appVersion) \(softwareVersion) \(platform) \(model) \(uuid) \(appId)"
    }
    
    
    func handleLoadRequest(url: URL?, reload: Bool = false) {
        
        if self.webView?.isLoading ?? false {
            self.webView?.stopLoading()
        }
        
        // 在这判断 网页http, 本地文件， html字符串加载显示
        // 或者协议在跳转
        if #available(iOS 13.0, *) {
            var windinUrl = url
            if windinUrl == nil {
                windinUrl = self.originalUrl()
            }
//            if let windinUrl = windinUrl, self.isWindinPDFUrl(url: windinUrl) {
//                if let data = try? Data(contentsOf: windinUrl) {
//                    self.webView?.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: windinUrl)
//                } else {
//                    self.addNoDataViewAndEnable()
//                }
//                return
//            }
        }
        
        if reload && url != nil {
            self.webView?.reload()
        } else {
            var requestUrl = url
            if requestUrl == nil {
                requestUrl = self.originalUrl()
            }
            if let requestUrl = requestUrl {
                if self.viewModel.cachePolicy == .useProtocolCachePolicy {
                    self.webView?.load(URLRequest(url: requestUrl))
                } else {
                    self.webView?.load(URLRequest(url: requestUrl, cachePolicy: self.viewModel.cachePolicy))
                }
            } else {
                // 兼容子类处理自己的加载逻辑
                self.webViewLoadRequest()
            }
        }
    }
    
    func addNoDataViewAndEnable() {
        if self.noDataView.superview != nil {
            self.noDataView.removeFromSuperview()
        }
        self.webView?.addSubview(self.noDataView)
        self.noDataView.isUserInteractionEnabled = true
    }
    
    func removeNoDataViewAndDisable() {
        if self.noDataView.superview != nil {
            self.noDataView.isUserInteractionEnabled = false
            self.noDataView.removeFromSuperview()
        }
    }
    
    
    func originalUrl() -> URL? {
        if let urlString = self.viewModel.url, urlString.hasPrefix("http") == false {
            return nil
        }
        if let urlString = self.viewModel.url, let url = URL(string: urlString) {
            return url
        }
        return nil
    }
    
    //富文本
    func contentString() -> String? {
        //处理html内容显示
        return nil
    }
    // 或者协议在跳转
    
    func webViewLoadRequest() {
        if let url = self.originalUrl() {
            self.handleLoadRequest(url: url)
        } else if let contenStr = self.contentString() {
            self.webView?.loadHTMLString(contenStr, baseURL: nil)
        }
    }

    func webViewWillLoadRequest() {
    }

    func webViewDidLoadRequest() {
    }


    func handleCurrentWebURL(_ url: URL) {
        let urlString = url.absoluteString
        if urlString.contains("/fund/index.html#/fund-details"){
            
            let param = self.getParametersFromURL(urlString)
        }
    }

    func getParametersFromURL(_ url: String) -> [String : String]  {
        let urlString = url as NSString
        let range = urlString.range(of: "?")

        var param: [String : String] = [:]

        if range.location == NSNotFound {
            return param
        } else {
            let subString = urlString.substring(from: range.location + 1)
            if subString.contains("&") {
                //多个参数
                let array = subString.components(separatedBy: "&")
                for str in array {
                    let subArray = str.components(separatedBy: "=")
                    if subArray.count > 1, let key = subArray.first?.removingPercentEncoding, let value = subArray.last?.removingPercentEncoding {
                        param[key] = value
                    }
                }

            } else {
                //只含有一个或0个参数
                let subArray = subString.components(separatedBy: "=")
                if subArray.count > 1, let key = subArray.first?.removingPercentEncoding, let value = subArray.last?.removingPercentEncoding {
                    param[key] = value
                }
            }
        }

        return param

    }
    
    func refreshWebview() {
        let url = self.webView?.url
        if self.startedNavigation {
            return
        }
        self.handleLoadRequest(url: url, reload: true)
    }

    
    fileprivate func finish() {
        let top: UIViewController? = navigationController?.viewControllers.last
        if top == self {
            // 该ViewController是navigationController的根视图，并且该navigationController是由某个ViewController present出来的
            // 那么，就将该navigationController进行dismiss的操作
            // 出现该场景的地方：衍生品风险提示
            if navigationController?.viewControllers.count == 1 && navigationController?.presentingViewController != nil {
                navigationController?.dismiss(animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            }
        } else {
            var array = navigationController?.viewControllers
            var i = (array?.count ?? 0) - 1
            while i >= 0 {
                if array?[i] == self {
                    array?.remove(at: i)
                    if let array = array {
                        navigationController?.viewControllers = array
                    }
                    break
                }
                i -= 1
            }
        }

    }
    
    
    //选中图片
    func chooseImage(withTitle title: String?, showFileAction: Bool = false, multiSelect: Bool = false, maxSelectCount: Int = 1) {
        
    }
    
    //MARK: 截屏分享的响应
    func showScreenShotShareView(withImage image: UIImage, successCallback: String?, errorCallback: String?) {
        // 分享结束后的回调
        let shareResultBlock: (Bool) -> Void = { [weak self] (result) in
            
            guard let `self` = self else { return }
            
            if result {
                YWProgressHUD.showSuccess("share_succeed", in: self.view)
                if  let webView = self.webView,
                    let successCallback = successCallback,
                    successCallback.count > 0 {
                    YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: "success", callback: successCallback)
                }
            } else {
                if let errorCallback = errorCallback,
                    errorCallback.count > 0,
                    let webView = self.webView {
                    YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "share failed", callback: errorCallback)
                }
            }
        }
        
        // more分享去掉提示
        let shareMoreResultBlock: (Bool) -> Void = { [weak self] (result) in
            guard let `self` = self else { return }
            if result {
                if  let webView = self.webView,
                    let successCallback = successCallback,
                    successCallback.count > 0 {
                    YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: "success", callback: successCallback)
                }
            } else {
                if let errorCallback = errorCallback,
                    errorCallback.count > 0,
                    let webView = self.webView {
                    YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "share failed", callback: errorCallback)
                }
            }
        }
        
        //分享
    }
}


extension YWWebCtrl: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        let alert = UIAlertController(title: YXLanguageUtility.kLang(key: "common_tips"), message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: YXLanguageUtility.kLang(key: "common_confirm"), style: .default, handler: { action in
//            completionHandler()
//        }))
//        self.present(alert, animated: true)
    }
}

extension YWWebCtrl: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //self.startedNavigation = true
//        if !(self.viewModel.webTitle?.isEmpty ?? true) {
//            self.titleView?.title = self.viewModel.webTitle
//        } else {
//            self.titleView?.title = "common_loading"
//        }
//
        self.progressView?.alpha = 1.0
        
        self.removeNoDataViewAndDisable()
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if SensorsAnalyticsSDK.sharedInstance()?.showUpWebView(webView, with: navigationAction.request, enableVerify: true) ?? false {
//            decisionHandler(.cancel)
//            return
//        } else
        if navigationAction.request.url?.scheme == "sms" || navigationAction.request.url?.scheme == "tel" || navigationAction.request.url?.scheme == "mailto" || navigationAction.request.url?.scheme == "itms-appss" {
            //url中是否含有拨打电话和邮件
            let app = UIApplication.shared
            if let url = navigationAction.request.url {
                if app.canOpenURL(url) {
                    //是被是否可以打开
                    app.open(url, options: [:], completionHandler: { success in
                    })
                }
            }
            decisionHandler(.cancel)
            return
        }

        if let url = navigationAction.request.url {
            self.handleCurrentWebURL(url)
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let urlString = webView.url?.absoluteString,
            YWGoToNativeManager.shared.schemeHasPrefix(string: urlString),
            YWGoToNativeManager.shared.gotoNativeViewController(withUrlString: urlString) {
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        //self.startedNavigation = false
        self.removeNoDataViewAndDisable()
//        if !(self.viewModel.webTitle?.isEmpty ?? true) {//self.viewModel.webTitle?.count ?? 0 > 0
//            self.titleView?.title = self.viewModel.webTitle
//        } else if self.titleView?.title == YXLanguageUtility.kLang(key: "common_loading") {
//            self.titleView?.title = ""
//        }
        
//        if let mj_header = self.webView?.scrollView.mj_header {
//            mj_header.endRefreshing()
//        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        self.titleView?.title = "webview_detailTitle"
        
        //self.startedNavigation = false
//        if let mj_header = self.webView?.scrollView.mj_header {
//            mj_header.endRefreshing()
//        }
        
        if (((error as NSError).code <= NSURLErrorBadURL && (error as NSError).code >= NSURLErrorNoPermissionsToReadFile)) || ((error as NSError).code <= NSURLErrorSecureConnectionFailed && (error as NSError).code >= NSURLErrorCannotLoadFromNetwork) || ((error as NSError).code <= NSURLErrorCannotCreateFile && (error as NSError).code >= NSURLErrorDownloadDecodingFailedToComplete) {
            self.addNoDataViewAndEnable()
        }
    }
}

extension YWWebCtrl: YWWKWebViewDelegate {
    //MARK: - onGet
    func onGetUserInfo(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: YWUserManager.userInfo, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8), let webView = self.webView, let successCallback = successCallback {
            YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: jsonString, callback: successCallback)
        }
    }
    
    func onGetDeviceInfo(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        let deviceInfo = [
            "deviceId": YWConstant.deviceInfo(),
            "platform": "iOS",
            "appId": YWConstant.bundleId,
            "appVersion": YWConstant.appVersion,
            "systemVersion": YWConstant.systemVersion
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: deviceInfo, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8), let webView = self.webView, let successCallback = successCallback {
            YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: jsonString, callback: successCallback)
        }
    }
    
    
    
    func onGetNotificationStatus(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        
//        self.isNotificationEnabled { [weak self] (result) in
//            guard let `self` = self else { return }
//
//            let status = [
//                "status": result ? "true" : "false"
//            ]
//
//            if let jsonData = try? JSONSerialization.data(withJSONObject: status, options: .prettyPrinted),
//                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8), let webView = self.webView, let successCallback = successCallback {
//                YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: jsonString, callback: successCallback)
//            }
//        }
    }
    
    func onGetAppConnectEnvironment(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        let connectEnv = [
            "value": YWConstant.targetModeName()
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: connectEnv, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8), let webView = self.webView, let successCallback = successCallback {
            YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: jsonString, callback: successCallback)
        }
    }
    
    func onGetHttpSign(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        if
            let xTransId = paramsJsonValue?["transId"] as? String,
            let xTime = paramsJsonValue?["timeStamp"] as? String,
            let xDt = paramsJsonValue?["devType"] as? String,
            let xDevId = paramsJsonValue?["devId"] as? String,
            let xUid = paramsJsonValue?["xUid"] as? String,
            let xLang = paramsJsonValue?["langType"] as? String,
            let xType = paramsJsonValue?["appType"] as? String,
            let xVer = paramsJsonValue?["version"] as? String
        {
            let xToken = ""
            
            let datas = [
                "xToken" : xToken
            ]
            
            if  let webView = self.webView,
                let jsonData = try? JSONSerialization.data(withJSONObject: datas, options: .prettyPrinted),
                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8),
                let successCallback = successCallback,
                successCallback.count > 0 {
                YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: jsonString, callback: successCallback)
            } else {
                if let errorCallback = errorCallback,
                    errorCallback.count > 0,
                    let webView = self.webView {
                    YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "get http sign failed", callback: errorCallback)
                }
            }
        } else {
            if let errorCallback = errorCallback,
                errorCallback.count > 0,
                let webView = self.webView {
                YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "get http sign failed", callback: errorCallback)
            }
        }
    }
    
    func onGetNFCRecognitionAvailability(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        
    }
    

    
    //MARK: - onCommand
    //MARK: 执行分享
    func onCommandShare(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        var resultDic = paramsJsonValue
        // shareType如果没有的话，则默认使用freedom
        let shareType: String = (paramsJsonValue?["shareType"] as? String) ?? "freedom"
        
        let title = (paramsJsonValue?["title"] as? String) ?? ""
        let description = paramsJsonValue?["description"] as? String
        let pageUrl = paramsJsonValue?["pageUrl"] as? String
        var shortUrl = paramsJsonValue?["shortUrl"] as? String
        //如果shortUrl没有值，那就用pageUrl
        if shortUrl?.isEmpty ?? true {//shortUrl?.count == 0
            shortUrl = pageUrl
        }
        let overseaPageUrl = paramsJsonValue?["overseaPageUrl"] as? String  //页面url
        
        let thumbUrl = paramsJsonValue?["thumbUrl"] as? String
        let image: Any = (thumbUrl?.isEmpty ?? true) ? UIImage(named: "icon")! : thumbUrl!
        
        let wxUserName = paramsJsonValue?["wxUserName"] as? String
        let wxPath = paramsJsonValue?["wxPath"] as? String
        let withShareTicket = paramsJsonValue?["withShareTicket"] as? Bool
        let miniProgramType = paramsJsonValue?["miniProgramType"] as? UInt
        
        let isDialogBgNone = paramsJsonValue?["isDialogBgNone"] as? Bool
        
        //let sharingImage = YWToolUtility.conventToImage(withBase64String: paramsJsonValue?["imageData"])
        
        let sharingImage = UIImage()
        
        // 分享结束后的回调
        let shareResultBlock: (Bool) -> Void = { [weak self] (result) in
            guard let `self` = self else { return }
            
            if result {
                YWProgressHUD.showSuccess("share_succeed", in: self.view)
                if  let webView = self.webView,
                    let successCallback = successCallback,
                    successCallback.count > 0 {
                    YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: "success", callback: successCallback)
                }
            } else {
                if let errorCallback = errorCallback,
                    errorCallback.count > 0,
                    let webView = self.webView {
                    YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "share failed", callback: errorCallback)
                }
            }
        }
        
        // more分享去掉提示
        let shareMoreResultBlock: (Bool) -> Void = { [weak self] (result) in
            guard let `self` = self else { return }
            if result {
                if  let webView = self.webView,
                    let successCallback = successCallback,
                    successCallback.count > 0 {
                    YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: "success", callback: successCallback)
                }
            } else {
                if let errorCallback = errorCallback,
                    errorCallback.count > 0,
                    let webView = self.webView {
                    YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "share failed", callback: errorCallback)
                }
            }
        }
        
        var pageURL = URL(string: pageUrl ?? "")
        
        //改变url的block
        let changeUrlBlock = {
            //let overseaLength = overseaPageUrl?.count, overseaLength > 0
            if !(overseaPageUrl?.isEmpty ?? true) {
                pageURL = URL(string: overseaPageUrl!)!
            }
        }
        
        // 分享
    }
    
    func onCommandCheckClientInstallStatus(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        let clients = paramsJsonValue?["clients"] as? [String]
        
        var status: [Bool] = []
        
//        clients?.forEach({ (client) in
//            if (client == "wechat" && YWShareSDKHelper.isClientIntalled(.typeWechat)) ||
//                (client == "whatsapp" && YWShareSDKHelper.isClientIntalled(.typeWhatsApp)) ||
//                (client == "facebook" && YWShareSDKHelper.isClientIntalled(.typeFacebook)) ||
//                (client == "twitter" && YWShareSDKHelper.isClientIntalled(.typeTwitter)) ||
//                (client == "messenger" && YWShareSDKHelper.isClientIntalled(.typeFacebookMessenger)) ||
//                (client == "qq" && YWShareSDKHelper.isClientIntalled(.typeQQ)) ||
//                (client == "weibo" && YWShareSDKHelper.isClientIntalled(.typeSinaWeibo)) {
//                status.append(true)
//            } else {
//                status.append(false)
//            }
//        })
        
        let data = [
            "status" : status
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8),
            let webView = self.webView,
            let successCallback = successCallback,
            successCallback.count > 0
        {
            YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: jsonString, callback: successCallback)
        } else {
            if let errorCallback = errorCallback,
                errorCallback.count > 0,
                let webView = self.webView {
                YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "获取第三方客户端状态失败", callback: errorCallback)
            }
        }
    }
    
    func onCommandCloseWebView(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "onCommandCloseWebView"), object: nil, userInfo: nil)
        self.finish()
    }
    
    func onCommandGoBack(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        if self.webView != nil {
            if self.webView?.canGoBack ?? false {
                self.webView?.goBack()
            } else {
                self.finish()
            }
        } else {
            self.finish()
        }
    }

    //设置title
    func onCommandSetTitle(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        //self.titleView?.title = paramsJsonValue?["title"] as? String
    }
    
    func onCommandUserLogin(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        if !YWUserManager.isLogin() {
            let loginCallBack: (([String: Any])->Void)? = { [weak self] (userInfo) in
                guard let `self` = self else { return }
                
                let jsonString = YWJSActionUtil.convertToJsonString(dict: userInfo)
                if YWUserManager.isLogin() {
                    if let jsonString = jsonString,
                        let webView = self.webView,
                        let successCallback = successCallback,
                        successCallback.count > 0 {
                        YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: jsonString, callback: successCallback)
                    }
                } else {
                    if let errorCallback = errorCallback,
                        errorCallback.count > 0,
                        let webView = self.webView {
                        YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "登录失败", callback: errorCallback)
                    }
                }
            }
            
            let cancelCallBack: (() -> Void)? = { [weak self] in
                guard let `self` = self else { return }
                if let errorCallback = errorCallback,
                    errorCallback.count > 0,
                    let webView = self.webView {
                    YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "登录失败", callback: errorCallback)
                }
            }
            
            // UIViewController.current() 防止控制器是其他控制器的子集
//            let context = YXNavigatable(viewModel: YXLoginViewModel(callBack: loginCallBack, cancelCallBack: cancelCallBack, vc: UIViewController.current()))
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.viewModel.navigator.push(YXModulePaths.defaultLogin.url, context: context)
//            }
        } else {
            if let errorCallback = errorCallback, errorCallback.count > 0, let webView = self.webView {
                YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "webview_js_userAlreadyLogin", callback: errorCallback)
            }
        }
    }
    
    func onCommandUserLogout(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        YWUserManager.loginOut(request: true)
    }
    
    func onCommandCopyToPasteboard(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        let content = paramsJsonValue?["content"] as? String
        if let content = content {
            let pab = UIPasteboard.general
            pab.string = content
            if let successCallback = successCallback, let webView = self.webView, !successCallback.isEmpty {
                YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: "success", callback: successCallback)
            }
        } else {
            if let errorCallback = errorCallback, let webView = self.webView, !errorCallback.isEmpty {
                YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "copy_failed", callback: errorCallback)
            }
        }
    }
    
    func onCommandOpenNotification(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        let application = UIApplication.shared
        let url = URL(string: UIApplication.openSettingsURLString)
        if let url = url {
            if application.canOpenURL(url) {
                application.open(url, options: [:], completionHandler: nil)
            }
        }
        
        if let successCallback = successCallback, let webView = self.webView, !successCallback.isEmpty {
            YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: "success", callback: successCallback)
        }
    }
    
    
    //MARK: 截屏分享
    func onCommandScreenshotShareSave(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        if let webView = self.webView {
            webView.swContentCapture { [weak self] (image) in
                guard let `self` = self else { return }
                
                if let image = image {
                    self.showScreenShotShareView(withImage: image, successCallback: successCallback, errorCallback: successCallback)
                }
            }
        } else {
            // 否则提示告知js失败了
            if
                let webView = self.webView,
                let errorCallback = errorCallback, errorCallback.count > 0 {
                YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "failed", callback: errorCallback)
            }
        }
    }
    //联系客服
    func onCommandContactService(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        
    }
    
    func onCommandSavePicture(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        
        
    }
    
    
    
    //从相机或相册中 获取图片
    func onGetImageFromCameraOrAlbum(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
//        self.chooseImageOrFileSuccessCallback = successCallback
//        self.chooseImageOrFileErrorCallback = errorCallback
//        self.fileMode = false
//        //选中图片
//        chooseImage(withTitle: paramsJsonValue?["title"] as? String)
    }
    
    //拍照从相册中获取多张图片
    func onGetMultiImageFromAlbum(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
//        self.chooseImageOrFileSuccessCallback = successCallback
//        self.chooseImageOrFileErrorCallback = errorCallback
//        self.fileMode = false
//
//        var maxCount = 1
//        if let count = paramsJsonValue?["maxCount"] as? String {
//            maxCount = Int(count) ?? 1
//        }else if let count = paramsJsonValue?["maxCount"] as? Int {
//            maxCount = count
//        }
//        chooseImage(withTitle: paramsJsonValue?["title"] as? String, multiSelect: true, maxSelectCount: maxCount)
    }
    
    

    
    func onGetImageOrFileFromCameraOrAlbumOrFileManager(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
//        self.chooseImageOrFileSuccessCallback = successCallback
//        self.chooseImageOrFileErrorCallback = errorCallback
//        self.fileMode = true
//        //选中图片
//        chooseImage(withTitle: paramsJsonValue?["title"] as? String, showFileAction: true)
    }
    
    func onCommandUploadElkLog(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        
        if let successCallback = successCallback, let webView = self.webView, !successCallback.isEmpty {
            YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: "success", callback: successCallback)
        }
        
    }
    
    func onCommandEnablePullRefresh(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        let enable = paramsJsonValue?["enable"] as? Bool
        
        if enable ?? false {
            self.webView?.scrollView.mj_header = self.refreshHeader
        } else {
            self.webView?.scrollView.mj_header = nil
        }
    }
    
    func onCommandRefreshUserInfo(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        if YWUserManager.isLogin() {
            YWUserManager.getUserInfo { [weak self] in
                guard let `self` = self else { return }
                
                if let successCallback = successCallback, let webView = self.webView, !successCallback.isEmpty {
                    YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: "success", callback: successCallback)
                }
            }
        } else {
            // 否则提示告知js失败了
            if
                let webView = self.webView,
                let errorCallback = errorCallback, errorCallback.count > 0 {
                YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "failed", callback: errorCallback)
            }
        }
    }
    //MARK: 打开NFC识别护照
    func onCommandNFCRecognizePassport(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        
//        var errorDesc: String = ""
//
//        if #available(iOS 13.0, *), YXToolUtility.getNFCAvailability() {
//
//            let passportNumber = paramsJsonValue?["passport_number"] as? String ?? ""
//            let dateOfBirth = paramsJsonValue?["date_of_birth"] as? String ?? ""
//            let expiryDate = paramsJsonValue?["expiry_date"] as? String ?? ""
//
//            let mrzKey = YXPassportDetailManager.getMRZKey(with: passportNumber, dateOfBirth, expiryDate)
//            let dataGroups : [DataGroupId] = [.COM, .DG1, .DG2, .SOD]
//
//            self.passportReader = PassportReader()
//
//            let readerTip = YXPassportReaderTip()
//            readerTip.readyTip = YXLanguageUtility.kLang(key: "nfc_ready_tip")
//            readerTip.readingTip = YXLanguageUtility.kLang(key: "nfc_reading_tip")
//            readerTip.errorTip = YXLanguageUtility.kLang(key: "nfc_error_tip")
//            readerTip.oneMoreTagsTip = YXLanguageUtility.kLang(key: "nfc_one_more_tags_tip")
//            readerTip.notValidTip = YXLanguageUtility.kLang(key: "nfc_not_valid_tip")
//            readerTip.connectErrorTip = YXLanguageUtility.kLang(key: "nfc_connect_error_tip")
//            readerTip.authenticatingTip = YXLanguageUtility.kLang(key: "nfc_authenticating_tip")
//
//            self.passportReader?.readPassport(mrzKey: mrzKey, tags: dataGroups,tip: readerTip, completed: { [weak self] (passport, error) in
//                guard let `self` = self else { return }
//                if let passport = passport {
//                    // All good, we got a passport 很好，我们有护照了
//                    let passportModel = Passport( fromNFCPassportModel: passport)
//
//                    var params = [String: String]()
//                    params["nationality"] = passportModel.nationality
//                    params["date_of_birth"] = passportModel.dateOfBirth
//                    params["gender"] = passportModel.gender
//                    params["document_expiry_date"] = passportModel.documentExpiryDate
//                    params["personal_number"] = passportModel.personalNumber
//                    params["last_name"] = passportModel.lastName
//                    params["first_name"] = passportModel.firstName
//                    params["issuing_authority"] = passportModel.issuingAuthority
//
//                    params["document_number"] = passportModel.documentNumber
//
//                    if let imageData = passportModel.image.pngData() {
//                        params["passport_image"] = imageData.base64EncodedString(options: [])
//                    } else {
//                        params["passport_image"] = ""
//                    }
//
//                    if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted),
//                        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8),
//                        let webView = self.webView, let successCallback = successCallback {
//
//                        YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: jsonString, callback: successCallback)
//                    } else {
//                        errorDesc = "other error"
//                    }
//
//                } else {
//                    errorDesc = error?.errorDescription ?? "Invalid response"
//                }
//
//                if errorDesc.count > 0,
//                    let webView = self.webView,
//                    let errorCallback = errorCallback, errorCallback.count > 0 {
//                    YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: errorDesc, callback: errorCallback)
//                }
//            })
//        } else {
//            errorDesc = "The system version is less than iOS 13.0 ,or your device is not support NFC."
//        }
//
//        if errorDesc.count > 0,
//            let webView = self.webView,
//            let errorCallback = errorCallback, errorCallback.count > 0 {
//            YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: errorDesc, callback: errorCallback)
//        }
        
        
    }

    //MARK: appsflyer事件上传
    func onCommandUploadAppsflyerEvent(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {

        
    }
    
    func onCommandBuyInAppProductEvent(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        
    }
    
    func onCommandProductConsumeResult(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
    }

    func onCommandHideTitlebar(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
    }
    
    func onCommandShowTitlebar(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
    }
    
    func onCommandSetScreenOrientation(withParamsJsonValue paramsJsonValue: Dictionary<String, Any>?, successCallback: String?, errorCallback: String?) {
        if let orientation = paramsJsonValue?["orientation"] as? Int {
            if orientation == 0 {
                // 竖屏
                //YWToolUtility.forceToPortraitOrientation()
                
                if let successCallback = successCallback, successCallback.count > 0, let webView = self.webView {
                    YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: "success", callback: successCallback)
                }
            } else if orientation == 1 {
                // 横屏
                //YWToolUtility.forceToLandscapeRightOrientation()
                
                if let successCallback = successCallback, successCallback.count > 0, let webView = self.webView {
                    YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: "success", callback: successCallback)
                }
            } else {
                if let errorCallback = errorCallback, errorCallback.count > 0, let webView = self.webView {
                    YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "upload appsflyer Event error", callback: errorCallback)
                }
            }
        } else {
            if let errorCallback = errorCallback, errorCallback.count > 0, let webView = self.webView {
                YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "upload appsflyer Event error", callback: errorCallback)
            }
        }
    }

    
    
}


//var kPassportReaderKey = 101
//@available(iOS 13.0, *)
//extension YWWebCtrl {
//    fileprivate var passportReader: PassportReader? {
//        set {
//            objc_setAssociatedObject(self, &kPassportReaderKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//
//        get {
//            objc_getAssociatedObject(self, &kPassportReaderKey) as? PassportReader
//        }
//    }
//}

extension YWWebCtrl: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as? String
        
        if (mediaType == kUTTypeImage as String) {
            let image: UIImage?
            if picker.allowsEditing {
                image = info[.editedImage] as? UIImage
            } else {
                image = info[.originalImage] as? UIImage
            }
            
            if let imageOriginal = image,
                let webView = self.webView {
                
                let image = self.normalizedImage(image: imageOriginal)
                
                let imageData = image.jpegData(compressionQuality: 0.7)
                if let imageData = imageData, let chooseImageSuccessCallback = self.chooseImageOrFileSuccessCallback {
                    let encodeData = imageData.base64EncodedString(options: [])
                    if self.fileMode ?? false {
                        let fileInfo = [
                            "fileName" : "",
                            "fileData" : encodeData
                        ]
                        if let chooseImageSuccessCallback = self.chooseImageOrFileSuccessCallback,
                            let jsonData = try? JSONSerialization.data(withJSONObject: fileInfo, options: .prettyPrinted),
                            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8),
                            let webView = self.webView {
                            YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: jsonString, callback: chooseImageSuccessCallback)
                        } else {
                            if let chooseImageErrorCallback = self.chooseImageOrFileErrorCallback, let webView = self.webView {
                                YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "choose_failed", callback: chooseImageErrorCallback)
                            }
                        }
                    } else {
                        YWJSActionUtil.invokeJSCallbackForSuccess(withWebview: webView, data: encodeData, callback: chooseImageSuccessCallback)
                    }
                } else {
                    if let chooseImageErrorCallback = self.chooseImageOrFileErrorCallback {
                        YWJSActionUtil.invokeJSCallbackForError(withWebview: webView, errorDesc: "choose_failed", callback: chooseImageErrorCallback)
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func save(_ image: UIImage, completionHandler: ((_ result: Bool) -> Void)? = nil) {
        
    }

    // MARK: - 解决图片自动旋转问题
    func normalizedImage(image: UIImage) -> UIImage {
        
        return image
        
//        if image.imageOrientation == UIImage.Orientation.up {
//            return image
//        }
        // 以下代码使用后,会使内存占用暴增,会导致在有些手机上内存紧张使webview被系统kill,所以注释此代码
//        UIGraphicsBeginImageContextWithOptions(image.size, _: false, _: image.scale)
//        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
//        let normalizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return normalizedImage ?? image
    }
    
    
    
}
//MARK: - MFMessageComposeViewControllerDelegate
extension YWWebCtrl: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
        switch result {
        case .sent:
            controller.shareResultBlock!(true)
            print("webview: send message success")
        case .failed:
            controller.shareResultBlock!(false)
            print("webview: send message failed")
        default:
            controller.shareResultBlock!(false)
            print("webview: default")
        }
    }
}


extension YWWebCtrl {
    
    //分享图片社区
    func shareToUsmartCommunity(_ image: UIImage?,shareResultBlock: ((Bool) -> Void)?) {
        
        
    }
    //MARK: 分享函数封装
    
    //MARK: 1.分享到短信
    fileprivate func shareToMessage(content: String?, sharingImage: UIImage?, imageUrlString: String?, shareResultBlock: ((Bool) -> Void)?) {
        // 分享短信
        // 1.判断能不能发短信
        if MFMessageComposeViewController.canSendText() {
            // 开始转菊花，进行图片下载
            
            let c = MFMessageComposeViewController()
            c.shareResultBlock = shareResultBlock
            c.body = content
            c.messageComposeDelegate = self
            let presentBlock: (_ image:UIImage?) -> Void = {[weak c,self] (image) in
                guard let strongC = c else {return}
                if let data = image?.pngData(), data.count > 0 {
                    strongC.addAttachmentData(data, typeIdentifier: "public.png", filename: "icon.png")
                    self.present(strongC, animated: true, completion: nil)
                }
                else if let data = image?.jpegData(compressionQuality: 1), data.count > 0 {
                    strongC.addAttachmentData(data, typeIdentifier: "public.jpeg", filename: "icon.png")
                    self.present(strongC, animated: true, completion: nil)
                }
                else {
                    self.present(strongC, animated: true, completion: nil)
                }
            }
            if MFMessageComposeViewController.canSendAttachments() {
                // 1. 仅支持jpg、png图片的短信分享
                // 2. 图片需要做缓存
                // 3. 图片下载完成后，present vc && 隐藏菊花
                // 4. 图片下载失败后，present vc (without image) && 隐藏菊花
                // 5. 没有需要分享的图片链接时，不需要分享图片
                // https://developer.apple.com/documentation/messageui/mfmessagecomposeviewcontroller/1614075-issupportedattachmentuti
                if MFMessageComposeViewController.isSupportedAttachmentUTI("public.png") ||
                    MFMessageComposeViewController.isSupportedAttachmentUTI("public.jpeg") {
                    if let sharingImage = sharingImage {
                        presentBlock(sharingImage)
                    } else {
                        if let imageUrlString = imageUrlString,imageUrlString.isEmpty == false {
                            self.networkingHUD.showLoading("", in: self.view)
                            let temp = URL(string: imageUrlString)!
//                            SDWebImageManager.shared.loadImage(with: temp, options: SDWebImageOptions.retryFailed, progress: { (_, _, _) in
//
//                            }) { [weak self] (image, data, error, cacheType, finished, imageURL) in
//                                self?.networkingHUD.hideHud()
//                                presentBlock(image)
//                            }
                        } else {
                            presentBlock(nil)
                        }
                    }
                } else {
                    presentBlock(nil)
                }
            } else {
                presentBlock(nil)
            }
        } else {
            // 不能发短信时
            shareResultBlock?(false)
            self.viewModel.hudSubject.onNext(.message("share_not_support_message", false))
        }
    }
    
    //MARK: 2.分享到更多
    fileprivate func shareToMore(activityItems: [Any], shareResultBlock: ((Bool) -> Void)?) {
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let completeBlock: UIActivityViewController.CompletionWithItemsHandler = { [weak vc] (activityType, completed, items, error) in
            guard let strongVC = vc else { return }
            shareResultBlock?(completed)
            if completed {
            } else {
            }
            strongVC.dismiss(animated: true, completion: nil)
        }
        vc.completionWithItemsHandler = completeBlock
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: 2.分享图片到指定平台
//    fileprivate func sharingImage(_ type: SSDKPlatformType, _ sharingImage: UIImage, _ shareResultBlock: ((Bool) -> Void)?) {
//        if type == .typeTwitter {
//            YWProgressHUD.showLoading("", in: self.view)
//        }
//        var shareAppText = ""
//        if YWShareManager.shared.isShareImageWithTitleSSDKType(type) {
//            shareAppText = YXLanguageUtility.kLang(key: "share_image_recommend_text")
//        }
//        
//        YWShareSDKHelper.shareInstance()?.share(type, text: shareAppText, images: [sharingImage], url: nil, title: "", type: .image, withCallback: {
//            [weak self] (success, userInfo, _) in
//            guard let `self` = self else { return }
//            if type == .typeTwitter {
//                YXProgressHUD.hide(for: self.view, animated: false)
//            }
//            shareResultBlock?(success)
//        })
//    }
}




public extension MFMessageComposeViewController {
    private struct AssociatedKey {
        static var shareResultBlock: String = "shareResultBlock"
    }
    var shareResultBlock: ((Bool) -> Void)? {
        get {
            (objc_getAssociatedObject(self, &AssociatedKey.shareResultBlock) as! (Bool) -> Void)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.shareResultBlock, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
