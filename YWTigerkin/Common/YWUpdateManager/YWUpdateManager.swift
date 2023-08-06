//
//  YWUpdateManager.swift
//  YWTigerkin
//
//  Created by odd on 8/5/23.
//

import UIKit
import CryptoSwift

class YWUpdateManager: NSObject {
    static let shared = YWUpdateManager()
    
    private let updateUrlKey = "updateUrlKey"
    private let latestVersionKey = "latestVersionKey"
    private let showedTimesKey = "showedTimesKey"
    private let latestShowTimeKey = "latestShowTimeKey"
    private let storeUrlKey = "storeUrlKey"
    
    @objc static let certFileName = YWMoyaConfig.certFileName

    @objc var updateUrlString: String {
        set {
            YWStoreManager.store(newValue, updateUrlKey)
        }
        get {
            let string = YWStoreManager.object(NSString.self, updateUrlKey) as? String
            return (string != nil) ? string! : ""
        }
    }
    
    @objc var updated: Bool = false
    
    // 用于记录是否关闭了升级窗口，或者确定无须升级
    @objc dynamic var finishedUpdatePop = false
    
    var latestVersion: String {
        set {
            YWStoreManager.store(newValue, latestVersionKey)

        }
        get {
            let string = YWStoreManager.object(NSString.self, latestVersionKey) as? String

            return (string != nil) ? string! : ""
        }
    }
    
    var showedTimes: Int32 {
        set {
            YWStoreManager.store(newValue, showedTimesKey)

        }
        get {
            YWStoreManager.int32(showedTimesKey)
        }
    }
    
    var latestShowTime: Int64 {
        set {
            YWStoreManager.store(newValue, latestShowTimeKey)

        }
        get {
            YWStoreManager.int64(latestShowTimeKey)
        }
    }
    
    var storeUrl: String {
        set {
            YWStoreManager.store(newValue, storeUrlKey)

        }
        get {
            YWStoreManager.object(NSString.self, storeUrlKey) as? String ?? ""
        }
    }
    
    @objc var needUpdate: Bool {
        get {
            self.latestVersion > (YWConstant.appVersion ?? "")
        }
    }
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetWorkChangeNotification), name: Notification.Name.init(rawValue: "kReachabilityChangedNotification"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func copy() -> Any {
        self
    }
    
    override func mutableCopy() -> Any {
        self
    }
    
    // MARK: - 有网络检查是否需要更新
    @objc func handleNetWorkChangeNotification(ntf: Notification) {
//        if let reachability = ntf.object as? YWNetWorkReachability {
//            let netWorkStatus = reachability.currentReachabilityStatus()
//
//            if self.updated == false, netWorkStatus != .notReachable {
//                checkUpdate()
//            }
//        }
    }
    
    func checkUpdate() {
        updateRequest()
    }
    
    func certificateCached() -> Bool {
        guard
            let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return false
        }
        
        let file = document.appendingPathComponent(YWUpdateManager.certFileName)
        return FileManager.default.fileExists(atPath: file.path)
    }
    
    func certificateFile() -> URL? {
        guard
            let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return nil
        }
        
        let file = document.appendingPathComponent(YWUpdateManager.certFileName)
        return file
    }
    
    func cachedCertificateMD5String() -> String {
        if
            certificateCached(),
            let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let file = document.appendingPathComponent(YWUpdateManager.certFileName)
            if let certData = try? Data.init(contentsOf: file) {
                return certData.md5
            }
        }
        return ""
    }
    
    func certificateFileMd5() -> String {
        // 1. 是否有缓存文件，如果有则先读取缓存文件
        if certificateCached() {
            return cachedCertificateMD5String()
        } else {
            // 2. 如果没有缓存文件，则读取内置文件
            if let url = Bundle.main.url(forResource: "certificate", withExtension: "cer"), let certData = try? Data.init(contentsOf: url) {
                return certData.md5
            }
        }
        return ""
    }
    
    func startDownloadCertificate(url: String, md5: String) {
        if let url = URL(string: url) {
            let semaphore = DispatchSemaphore (value: 0)
            
            var request = URLRequest(url: url,timeoutInterval: 3000)
            request.httpMethod = "GET"

            let task = URLSession.shared.downloadTask(with: request) { (url, response, error) in
                guard
                    let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                    let url = url
                else {
                    semaphore.signal()
                    return
                }

                do {
                    if let tmpCertData = try? Data.init(contentsOf: url),
                       tmpCertData.md5 == md5 {
                        
                        let file = document.appendingPathComponent(YWUpdateManager.certFileName)
                        
                        // 如果文件已经存在，则先尝试移除文件
                        if FileManager.default.fileExists(atPath: file.path) {
                            try FileManager.default.removeItem(at: file)
                        }
                        try FileManager.default.moveItem(atPath: url.path,
                                                         toPath: file.path)
                        
                        // 提醒用户重新启动App
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                            let message = YWLanguageUtility.kLang(key: "cert_renewal_tip")
//                            let confirm = UIAlertAction(title: YWLanguageUtility.kLang(key: "cert_reboot"), style: .default) { (alertController, action) in
//                                exit(0)
//                            }
//                            let alertController = UIAlertController(title: YWLanguageUtility.kLang(key: "cert_update"), message: message, preferredStyle: .alert)
//                            alertController.addAction(confirm)
//                            alertController.showWith(animated: true)
                        }
                    } else {
                        try FileManager.default.removeItem(at: url)
                        
                        // 如果下载的文件MD5与服务器下发的MD5不一样，证明文件下载不完整
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            // 提醒用户重新启动App
//                            let message = YWLanguageUtility.kLang(key: "cert_invalid_tip")
//                            let confirm = UIAlertAction(title: YWLanguageUtility.kLang(key: "cert_reboot"), style: .default) { (alertController, action) in
//                                exit(0)
//                            }
//                            let alertController = UIAlertController(title: YWLanguageUtility.kLang(key: "cert_update"), message: message, preferredStyle: .alert)
//                            alertController.addAction(confirm)
//                            alertController.showWith(animated: true)
                        }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                semaphore.signal()
            }

            task.resume()
            semaphore.wait()
        }
    }
    
    func updateRequest() {
        
        self.updateUrlString = "http://itunes.apple.com/cn/lookup?id=123456"
        
        var updateType = 4
        let strongSelf = self
        let version = "1.0.1"
        let title = "更新"
        let content = "描述：\n1：更新初始；\n2：更新活动；\n3：优化体验；"
        let prompt = "活动开始了，最新来袭"
        let systemTime:Int64 = 1000
        
        let times = 3
        let seconds = 1 * 24 * 60 * 60
        
        switch updateType {
        case 1://强制升级
            strongSelf.latestShowTime = systemTime
            strongSelf.showedTimes = strongSelf.showedTimes + 1

            let alertView = YWUpdateAlertView(title: title + " V" + version, message: content, prompt:prompt)
            alertView.clickedAutoHide = false

            alertView.addAction(YWUpdateAlertAction(title: YWLanguageUtility.kLang(key: "common_go_update"), style: .fullDefault, handler: { (action) in
                if let url = URL(string: strongSelf.updateUrlString) {
                    UIApplication.shared.open(url, completionHandler: nil)
                } else {
                    alertView.dismiss()
                }
            }))
                alertView.showAlert()
            break;
        case 2://可取消升级
            if strongSelf.latestVersion < version {
                strongSelf.showedTimes = 1
                strongSelf.latestShowTime = systemTime

                let alertView = YWUpdateAlertView(title: title + " V" + version, message: content, prompt:prompt)
                alertView.clickedAutoHide = true

                alertView.addAction(YWUpdateAlertAction(title: YWLanguageUtility.kLang(key: "common_go_update"), style: .fullDefault, handler: { (action) in
                    if let url = URL(string: strongSelf.updateUrlString) {
                        UIApplication.shared.open(url, completionHandler: nil)
                    }
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: .kNotificationName), object: nil, userInfo:nil)
                }))

                alertView.addAction(YWUpdateAlertAction(title: YWLanguageUtility.kLang(key: "common_cancel_update"), style: .fullCancel, handler: { (action) in
                    
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: .kNotificationName), object: nil, userInfo:nil)
                }))
                alertView.showAlert()
                
            } else if  strongSelf.latestVersion == version, strongSelf.showedTimes < times, systemTime - strongSelf.latestShowTime > seconds {
                strongSelf.showedTimes = strongSelf.showedTimes + 1
                strongSelf.latestShowTime = systemTime

                let alertView = YWUpdateAlertView(title: title + " V" + version, message: content, prompt:prompt)
                alertView.clickedAutoHide = true

                alertView.addAction(YWUpdateAlertAction(title: YWLanguageUtility.kLang(key: "common_go_update"), style: .fullDefault, handler: { (action) in
                    if let url = URL(string: strongSelf.updateUrlString) {
                        UIApplication.shared.open(url)
                    }
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: .kNotificationName), object: nil, userInfo:nil)
                }))

                alertView.addAction(YWUpdateAlertAction(title: YWLanguageUtility.kLang(key: "common_cancel_update"), style: .fullCancel, handler: { (action) in
                    
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: .kNotificationName), object: nil, userInfo:nil)
                }))
                
                alertView.showAlert()
                
            } else {
                strongSelf.finishedUpdatePop = true
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: ..kNotificationName), object: nil, userInfo:nil)
            }

            break;
        case 3://手动升级
            strongSelf.finishedUpdatePop = true
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: YWPopManager.kNotificationName), object: nil, userInfo:nil)

            break;

        default:
            strongSelf.finishedUpdatePop = true
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: YWPopManager.kNotificationName), object: nil, userInfo:nil)
            break;
        }
        
        
//        let requestModel = YWUpdateRequestModel()
//        requestModel.yhc = self.certificateFileMd5()
//        let request = YWRequest(request: requestModel)
//        request.startWithBlock(success: { [weak self] (model)  in
//            guard let strongSelf = self else { return }
//            if let responeModel = model as? YXUpdateResponseModel, responeModel.code == .success  {
//                // 如果后台有返回新的证书，则下载新的https证书，并在下载完毕后提醒用户重新启动App
//                if !responeModel.fileUrl.isEmpty {
//                    // 如果后台返回了证书下载地址，则证明有新证书了，应该下载新证书
//                    strongSelf.startDownloadCertificate(url: responeModel.fileUrl, md5: responeModel.md5)
//                }
//                if strongSelf.updated == true {
//                    return
//                }
//                strongSelf.updated = true
//
//                let version = responeModel.versionNo
//                if responeModel.update {
//                    let title = responeModel.title
//                    let content = responeModel.content
//                    let systemTime = responeModel.systemTime
//                    let times = responeModel.times
//                    let seconds = responeModel.seconds
//
//                    strongSelf.updateUrlString = responeModel.filePath
//                    switch responeModel.updateMode {
//                    case 1://强制升级
//                        strongSelf.latestShowTime = systemTime
//                        strongSelf.showedTimes = strongSelf.showedTimes + 1
//
//                        let alertView = YXUpdateAlertView(title: title + " V" + version, message: content, prompt:"")
//                        alertView.clickedAutoHide = false
//
//                        alertView.addAction(YXUpdateAlertAction(title: YXLanguageUtility.kLang(key: "common_go_update"), style: .fullDefault, handler: { (action) in
//                            if let url = URL(string: strongSelf.updateUrlString) {
//                                UIApplication.shared.open(url, completionHandler: nil)
//                            } else {
//                                alertView.hide()
//                            }
//                        }))
//                            alertView.showInWindow()
//                        break;
//                    case 2://可取消升级
//                        if strongSelf.latestVersion < version {
//                            strongSelf.showedTimes = 1
//                            strongSelf.latestShowTime = systemTime
//
//                            let alertView = YXUpdateAlertView(title: title + " V" + version, message: content, prompt:"")
//                            alertView.clickedAutoHide = false
//
//                            alertView.addAction(YXUpdateAlertAction(title: YXLanguageUtility.kLang(key: "common_go_update"), style: .fullDefault, handler: { (action) in
//                                if let url = URL(string: strongSelf.updateUrlString) {
//                                    UIApplication.shared.open(url, completionHandler: nil)
//                                }
//                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXPopManager.kNotificationName), object: nil, userInfo:nil)
//                            }))
//
//                            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: YXConstant.screenWidth, height: YXConstant.screenHeight))
//                            bgView.addSubview(alertView)
//
//                            let button = UIButton(type: .custom)
//                            button.setImage(UIImage(named: "pop_close_update"), for: .normal)
//                            bgView.addSubview(button)
//
//                            _ = button.rx.tap.subscribe(onNext: { (_) in
//                                strongSelf.finishedUpdatePop = true
//                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXPopManager.kNotificationName), object: nil, userInfo:nil)
//                                bgView.hide()
//                            })
//
//                            button.snp.makeConstraints { (make) in
//                                make.width.height.equalTo(37)
//                                make.top.equalTo(alertView.snp.bottom).offset(30)
//                                make.centerX.equalToSuperview()
//                            }
//                            bgView.showInWindow()
//
//                        } else if  strongSelf.latestVersion == version, strongSelf.showedTimes < times, systemTime - strongSelf.latestShowTime > seconds {
//                            strongSelf.showedTimes = strongSelf.showedTimes + 1
//                            strongSelf.latestShowTime = systemTime
//
//                            let alertView = YXUpdateAlertView(title: title + " V" + version, message: content, prompt:"")
//                            alertView.clickedAutoHide = false
//
//                            alertView.addAction(YXUpdateAlertAction(title: YXLanguageUtility.kLang(key: "common_go_update"), style: .fullDefault, handler: { (action) in
//                                if let url = URL(string: strongSelf.updateUrlString) {
//                                    UIApplication.shared.open(url)
//                                }
//                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXPopManager.kNotificationName), object: nil, userInfo:nil)
//                            }))
//
//                            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: YXConstant.screenWidth, height: YXConstant.screenHeight))
//                            bgView.addSubview(alertView)
//
//                            //关闭按钮
//                            let button = UIButton(type: .custom)
//                            button.setImage(UIImage(named: "pop_close_update"), for: .normal)
//                            bgView.addSubview(button)
//
//                            _ = button.rx.tap.subscribe(onNext: { (_) in
//                                strongSelf.finishedUpdatePop = true
//                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXPopManager.kNotificationName), object: nil, userInfo:nil)
//                                bgView.hide()
//                            })
//
//                            button.snp.makeConstraints { (make) in
//                                make.width.height.equalTo(37)
//                                make.top.equalTo(alertView.snp.bottom).offset(30)
//                                make.centerX.equalToSuperview()
//                            }
//                            bgView.showInWindow()
//                        } else {
//                            strongSelf.finishedUpdatePop = true
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXPopManager.kNotificationName), object: nil, userInfo:nil)
//                        }
//
//                        break;
//                    case 3://手动升级
//                        strongSelf.finishedUpdatePop = true
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXPopManager.kNotificationName), object: nil, userInfo:nil)
//
//                        break;
//
//                    default:
//                        strongSelf.finishedUpdatePop = true
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXPopManager.kNotificationName), object: nil, userInfo:nil)
//                        break;
//                    }
//                } else {
//                    strongSelf.showedTimes = 0
//                    strongSelf.finishedUpdatePop = true
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXPopManager.kNotificationName), object: nil, userInfo:nil)
//                }
//
//                strongSelf.latestVersion = version
//            }else{
//                self?.finishedUpdatePop = true
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXPopManager.kNotificationName), object: nil, userInfo:nil)
//            }
//
//        }) { [weak self](request) in
//
//        }
    }
    
    func showUpdateAlert() {
        
        self.updateUrlString = "http://itunes.apple.com/cn/lookup?id=123456"
        
        var updateType = 2
        let strongSelf = self
        let version = "1.0.1"
        let title = "更新"
        let content = "描述：\n1：更新初始；\n2：更新活动；\n3：优化体验；"
        let prompt = "活动开始了，最新来袭"
        let systemTime:Int64 = 1000
        
        let times = 3
        let seconds = 1 * 24 * 60 * 60
        
        let alertView = YWUpdateAlertView(title: title + " V" + version, message: content, prompt:prompt)
        alertView.clickedAutoHide = true

        alertView.addAction(YWUpdateAlertAction(title: YWLanguageUtility.kLang(key: "common_go_update"), style: .fullDefault, handler: { (action) in
            if let url = URL(string: strongSelf.updateUrlString) {
                UIApplication.shared.open(url, completionHandler: nil)
            }
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: .kNotificationName), object: nil, userInfo:nil)
        }))

        alertView.addAction(YWUpdateAlertAction(title: YWLanguageUtility.kLang(key: "common_cancel_update"), style: .fullCancel, handler: { (action) in
            
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: .kNotificationName), object: nil, userInfo:nil)
        }))
        alertView.showAlert()
    }
}

