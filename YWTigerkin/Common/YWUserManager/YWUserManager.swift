//
//  YWUserManager.swift
//  YWTigerkin
//
//  Created by odd on 7/15/23.
//

import UIKit
import RxSwift

class YWUserManager: NSObject {

    public static let YXCurToken = "YXCurToken"

    public static let YWUser =  "YWUser"
    public static let YWUserToken = "YWUserToken"
    public static let YWUserUUID = "YWUserUUID"
    public static let YWLanguage =  "YWLanguage"
    public static let YWDefCode =  "YWDefCode"
    public static let YWLoginType =  "YWLoginType"
    
    //广告闪屏页的 日期缓存
    public static let YWAdvertiseDateCache =  "YWAdvertiseDateCache"
    
    //广告闪屏页的 日期缓存
    public static let YWSystemIPOAlertDateCache =  "YWSystemIPOAlertDateCache"
    
    //闪屏广告
    public static let YWSplashScreenAdvertisement = "YWSplashScreenAdvertisement"
    //正在展示的闪屏广告
    public static let YWSplashScreenAdvertisementShowing = "YWSplashScreenAdvertisementShowing"
    //闪屏广告 图片
    public static let YWSplashScreenImage = "YWSplashScreenImage"
    //已经展示过的闪屏广告代码
    public static let YWSplashScreenImageHasReadCodes = "YWSplashScreenImageHasReadCodes"
    
    static let instance: YWUserManager = YWUserManager()

    class func shared() -> YWUserManager {
        return instance
    }
    
    lazy var testImgView:UIImageView = {
       return UIImageView()
    }()
    
    override init() {
        super.init()
        
        setLocationData()
    }
    var defCode = "1"
    let disposeBag = DisposeBag()

    var curLoginUser: YWLoginUser?
//    var userBanner: YWUserBanner?

    //当前券商token
    @objc var curToken:String{
        get{
            let mmkv = MMKV.default()
            return  mmkv?.string(forKey: YWUserManager.YXCurToken) ?? ""
        }
        set{
            let mmkv = MMKV.default()
            mmkv?.set(newValue, forKey: YWUserManager.YXCurToken)
        }
    }
    public class func checkLogin(_ loginBlock: @escaping(Bool) ->Void, isLogin: Bool? = false) {
        if YWUserManager.isLogin() {
            loginBlock(true)
            return
        } else if isLogin == false {
            loginBlock(false)
        }
        
        //强制登录，暂时的逻辑
        if isLogin == true {
            
            let callback: (([String: Any])->Void)? = { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    loginBlock(true)
                })
            }

            
            let loginViewModel = YWLoginViewModel(callBack: callback, vc: nil)
            let context = YWNavigatable(viewModel: loginViewModel)

            YWWAppDelegate?.navigator.presentPath(YWModulePaths.login.url, context: context, animated: true)
        }
    }
    public class func isLogin() -> Bool {
        
        let token = YWUserManager.instance.curLoginUser?.token
        //print("token: \(String(describing: token))")
        return !(token?.isEmpty ?? true)   //token?.count ?? 0 > 0
    }
    
    public func token() -> String {
        YWUserManager.instance.curLoginUser?.token ?? ""
    }
    
    class var userInfo: [String : Any] {
        let userId = String(format: "%llu", YWUserManager.userUUID())
        let userName = YWUserManager.shared().curLoginUser?.nickName ?? ""
        let userToken = YWUserManager.shared().curLoginUser?.token ?? ""
    
        let userInfo = [
            "userId": userId,
            "userName": userName,
            "userToken": userToken]
        
        return userInfo
    }
    
    class func userUUID() -> String {
        if YWUserManager.isLogin() {
            return YWUserManager.shared().curLoginUser?.userId ?? ""
        }else {
            return ""
        }
    }
    
    //退出登录
    class func loginOut(request: Bool) {
        if YWUserManager.isLogin() {
            
            YWUserManager.shared().curLoginUser = nil
            YWUserManager.shared().curToken = ""
            
            
            let mmkv = MMKV.default()
            mmkv?.removeValues(forKeys: [YWUser, YWUserUUID, YWUserToken,YXCurToken])
            
//            NotificationCenter.default.post(name: NSNotification.Name(YWUserManager.notiLoginOut), object: nil)
//            NotificationCenter.default.post(name: NSNotification.Name(YWUserManager.notiUpdateUUID), object: nil)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(YWUserManager.notiUpdateResetRootView), object: nil)
        
    }
    
    class func saveCurLoginUser() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(YWUserManager.shared().curLoginUser)
            let mmkv = MMKV.default()
            mmkv?.set(data, forKey: YWUserManager.YWUser)
//            let uuid = NSNumber(value: YWUserManager.shared().curLoginUser?.userId)
            mmkv?.set(YWUserManager.shared().curLoginUser?.userId ?? "", forKey: YWUserUUID)
            mmkv?.set(YWUserManager.shared().curLoginUser?.token ?? "", forKey: YWUserToken)
            
        } catch {
            
        }
    }
    
    /// 设置登录信息
    class func setLoginInfo(user: YWLoginUser?) {
        YWUserManager.shared().curLoginUser = user
        YWUserManager.saveCurLoginUser()
        //YWUserManager.getUserBanner(complete: nil)
        
        if let appfirstLogin = YWUserManager.shared().curLoginUser?.appfirstLogin, appfirstLogin == true {
            // 注册
        } else {
            // 登录
        }

    }
    //MARK: 加载本地数据
    func setLocationData() { //加载本地数据
        
        
        let mmkv = MMKV.default()
        let data = mmkv?.data(forKey: YWUserManager.YWUser)
        do {
            let user = try JSONDecoder().decode(YWLoginUser.self, from: data ?? Data())
            self.curLoginUser = user
            let token = mmkv?.string(forKey: YWUserManager.YWUserToken)
            if self.curLoginUser != nil && token?.count ?? 0 == 0{
//                let uuid = NSNumber(value: self.curLoginUser?.uuid ?? 0)
                mmkv?.set(self.curLoginUser?.userId ?? "", forKey: YWUserManager.YWUserUUID)
                mmkv?.set(self.curLoginUser?.token ?? "", forKey: YWUserManager.YWUserToken)
            }
        } catch {
            
        }
        
//        let bannerData = mmkv?.data(forKey: YWUserManager.YWBanner)
//        do {
//            let banner = try JSONDecoder().decode(YWUserBanner.self, from: bannerData ?? Data())
//            self.userBanner = banner
//        } catch {
//
//        }
        
        setNotification()
    }
    //设置网络通知
    func setNotification() {
       
        _ = NotificationCenter.default.rx
            .notification(NSNotification.Name.init("kReachabilityChangedNotification"))
            .take(until: self.rx.deallocated)
            .subscribe(onNext: {[weak self] ntf in
                guard let strongSelf = self else { return }
                
            })

        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name(TokenFailureNotification), object: nil, queue: OperationQueue.main, using: { [weak self] (ntf) in
            //self?.tokenFailureAction()
        })
        
        //后台进入前台 刷新用户信息
        _ = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: OperationQueue.main, using: { (ntf) in
            if YWUserManager.isLogin() {
                
            }
        })

    }
    
    class func getUserInfo (postNotification: Bool = true, activateToken: Bool = false, complete: (()-> Void)?) {
        
        if !YWUserManager.isLogin() {
            if let complete = complete {
                complete()
            }
        }
        
        /*获取用户信息
         user-info-aggregation/v1  */
//        if let appDelegate = YWConstant.sharedAppDelegate as? AppDelegate {
//            appDelegate.appServices.aggregationService.request(.updateUserInfo(activateToken), response: { (response) in
//                
//                switch response {
//                case .success(let result, let code):
//                    switch code {
//                    case .success?:
//                        //为解决 ： 已退出状态，token失效，但是还返回了用户信息，就会出现 已经退出，但是还是登录状态
//                        if YWUserManager.isLogin() {
//                            //拿到以前的token，保留之前的token，因为【获取用户信息】不会返回token
//                            //expiration /token，刷新用戶信息时，都不会返回给我们  2019-06-06
//                            let tradePassword = YWUserManager.shared().curLoginUser?.tradePassword
//                            let token = YWUserManager.shared().curLoginUser?.token
//                            let expiration = YWUserManager.shared().curLoginUser?.expiration
//                            YWUserManager.shared().curLoginUser = result.data //更新用户信息
//                            if let v = tradePassword {
//                                YWUserManager.shared().curLoginUser?.tradePassword = v
//                            }
//                            YWUserManager.shared().curLoginUser?.token = token
//                            YWUserManager.shared().curLoginUser?.expiration = expiration
//                            
//                            YWUserManager.saveCurLoginUser()
//                            // 发送用户信息更新的通知
////                            if postNotification {
////                                NotificationCenter.default.post(name: NSNotification.Name(YWUserManager.notiUpdateUserInfo), object: nil)
////                            }
//                            //请求是否设置交易密码
//                         //   YXTradePwdManager.shared().checkSetTradePwd(nil) { (isSet) in }
//                        } else {
//                            
//                        }
//                        
//                        break
//                    case .aggregationError?,
//                         .aggregationHalfError?,
//                         .aggregationUserError?,
//                         .aggregationStockError?,
//                         .aggregationProductError?,
//                         .aggregationInfoError?,
//                         .aggregationLoginError?,
//                         .aggregationRegistError?,
//                         .aggregationMoneyError?,
//                         .aggregationPermissionsError?,
//                         .aggregationWechatError?,
//                         .aggregationWeiboError?:
//                        YWProgressHUD.showError("common_net_error")
//                    default:
//                        if let msg = result.msg {
//                            YWProgressHUD.showError(msg)
//                        }
//                    }
//                case .failed(_):
//                    YWProgressHUD.showError("common_net_error")
//                }
//                
//                if let complete = complete {
//                    complete()
//                }
//                
//                } as YWResultResponse<YWLoginUser>).disposed(by: YWUserManager.shared().disposeBag)
//        }
        
    }
    
    class func safeDecrypt(string: String) -> String {  //RSA加密
        string
    }
    
    //获取闪屏广告
    class func getSplashscreenAdvertisement(complete:(()-> Void)?) {
        if let appDelegate = YWConstant.sharedAppDelegate as? YWAppDelegate {
            
            var imgArr:[SplashscreenList] = []
            for i in 0...3 {
                
                var model = SplashscreenList(bannerID: (100 + i), adType: i, adName: "name_\(i)", adPos: i, pictureURL: "https://lmg.jj20.com/up/allimg/tp10/2109261124125L4-0-lp.jpg", jumpType: "", invalidTime: "", originJumpURL: "ywtigerkin://action?actiontype=5&url=5&name=woment&source=deeplink", newsID: "", tag: "200\(i)")
                if i == 1 {
                    model = SplashscreenList(bannerID: (100 + i), adType: i, adName: "name_\(i)", adPos: i, pictureURL: "https://fastly.picsum.photos/id/847/200/300.jpg?hmac=c59lDNOau0hCfCBs141cA-vqX8QIRiqaVEnT3tRrDe0", jumpType: "", invalidTime: "", originJumpURL: "ywtigerkin://action?actiontype=5&url=5&name=woment&source=deeplink", newsID: "", tag: "200\(i)")
                } else if i == 2 {
                    model = SplashscreenList(bannerID: (100 + i), adType: i, adName: "name_\(i)", adPos: i, pictureURL: "https://fastly.picsum.photos/id/1060/200/300.jpg?hmac=xYtFmeYcfydIF3-Qybnra-tMwklX69T52EtGd-bacBI", jumpType: "", invalidTime: "", originJumpURL: "ywtigerkin://action?actiontype=5&url=5&name=woment&source=deeplink", newsID: "", tag: "200\(i)")
                } else if i == 3 {
                    model = SplashscreenList(bannerID: (100 + i), adType: i, adName: "name_\(i)", adPos: i, pictureURL: "https://fastly.picsum.photos/id/1081/200/300.jpg?hmac=ntCnXquH7cpEF0vi5yvz1wKAlRyd2EZwZJQbgtfknu8", jumpType: "", invalidTime: "", originJumpURL: "ywtigerkin://action?actiontype=5&url=5&name=woment&source=deeplink", newsID: "", tag: "200\(i)")
                }
                
                imgArr.append(model)
            }
            let splashScreenList:YWSplashScreenList = YWSplashScreenList(dataList: imgArr)

            let picUrl = imgArr.first!.pictureURL ?? ""
            YWUserManager.shared().testImgView = UIImageView()
            YWUserManager.shared().testImgView.yy_setImage(with: URL(string: picUrl), placeholder: nil, options: []) { img, url, formType, stage, error in
               if error == nil {
                   if let imageData = img?.pngData() {
                       let mmkv = MMKV.default()
                       mmkv?.set(imageData, forKey: YWUserManager.YWSplashScreenImage)

                   }
               }
           }
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                //返回为空也保存，覆盖之前的数据
                let data = try encoder.encode(splashScreenList)
                let mmkv = MMKV.default()
                mmkv?.set(data, forKey: YWUserManager.YWSplashScreenAdvertisement)

            } catch {

            }
            
            
            
            /* -- 闪屏广告
             get请求
            */
//            appDelegate.appServices.newsService.request(.splashScreenAdvertisement, response:{(response) in
//                if let complete = complete {
//                    complete()
//                }
//                switch response {
//                case .success(let result, let code):
//                    switch code {
//                    case .success?:
//                        if let dataArr = result.data?.dataList, dataArr.count > 0 {
//                              let splashItem = dataArr.min { //取出优先级最靠前的广告
//                                  $0.adPos ?? 0 < $1.adPos ?? 0
//                              }
//                            let picUrl = URL(string: splashItem.pictureURL ?? "")
//
//                            let imgView = UIImageView()
//                            imgView.yy_setImage(with: picUrl, placeholder: nil, options: []) { img, url, formType, stage, error in
//                                if error == nil {
//                                    if let imageData = img?.pngData() {
//                                        let mmkv = MMKV.default()
//                                        mmkv?.set(imgData, forKey: YWUserManager.YWSplashScreenImage)
//
//                                    }
//                                }
//                            }
//
//                        }
//
//                        let encoder = JSONEncoder()
//                        encoder.outputFormatting = .prettyPrinted
//                        do {
//                            //返回为空也保存，覆盖之前的数据
//                            let data = try encoder.encode(result.data)
//                            let mmkv = MMKV.default()
//                            mmkv?.set(data, forKey: YWUserManager.YWSplashScreenAdvertisement)
//                            
//                        } catch {
//                            
//                        }
//                        break
//                    default:
//                        if let msg = result.msg {
//                            YWProgressHUD.showError(msg)
//                        }
//                    }
//                case .failed(_): break
////                    YWProgressHUD.showError(YWLanguageUtility.kLang(key: "common_net_error"))
//                }
//                }as YWResultResponse<SplashscreenList>).disposed(by: YWUserManager.shared().disposeBag)
        }
    }
    
}


extension YWUserManager {
    
    /// 当前选择的语言
    /// 1简体2繁体3英文
    /// - Returns: 选择的语言
    class func curLanguage() -> YWLanguageType {
//        let mmkv = MMKV.default()
//        mmkv.set(Int32(YXLanguageType.EN.rawValue), forKey: YXUserManager.YXLanguage)
//        return YXLanguageType.EN
        let mmkv = MMKV.default()
        let curLanguage = mmkv?.int32(forKey: YWUserManager.YWLanguage) ?? 0
        
        if curLanguage == 0 { //没有存储
            var defaultLanguage:YWLanguageType = .CN
            let languages = NSLocale.preferredLanguages
            let language = languages.first
            //zh_Hans 表示简体中文
            if language?.hasPrefix("zh-Hans") ?? false {//简体
                defaultLanguage = .CN
            } else if language?.hasPrefix("zh-Hant") ?? false {//繁体
                defaultLanguage = .HK
            } else if language?.hasPrefix("ms") ?? false {//马来语
                defaultLanguage = .ML
            } else if language?.hasPrefix("th") ?? false {//泰语
                defaultLanguage = .TH
            }
            mmkv?.set(Int32(defaultLanguage.rawValue), forKey: YWUserManager.YWLanguage)
            return defaultLanguage
        }
        return YWLanguageType(rawValue: Int(curLanguage)) ?? YWLanguageType.CN  //有存储
    }
    
    /// 是否当前语言是英文的模式.
    @objc class func isENMode() -> Bool {
        let lang = self.curLanguage()
        if lang == .EN || lang == .TH || lang == .ML {
            return true
        } else {
            return false
        }
    }
    
    /// 是否是同一天
    /// cacheNow: 是否立即保存日期字符串
    class func isTheSameDay(with key: String,cacheNow: Bool = true) -> (Bool,String) {
        //获取东八区的当前时间
        let eastEightZone = NSTimeZone.init(name: "Asia/Shanghai") as TimeZone?
        let dateFormatter = DateFormatter.en_US_POSIX()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = eastEightZone
        let now = Date()
        
        let lastDateString = MMKV.default()?.string(forKey: key)
        let nowDateString = dateFormatter.string(from: now)
        
        //一天只展示一次
        if lastDateString != nowDateString {
            if cacheNow {
                MMKV.default()?.set(nowDateString, forKey: key)
            }
            return (false,nowDateString)
        }
        return (true,nowDateString)
    }
}


extension YWUserManager {
    
    public static let notiUpdateUUID      = "noti_updateUUID"                 //uuid 改变
    public static let notiLogin           = "noti_login"                      //登录成功
    public static let notiLoginOut        = "noti_loginOut"                   //退出登录
    public static let notiUpdateUserInfo        = "noti_updateUserInfo"       //更新用户信息
    public static let notiUpdateToken           = "noti_updateToken"          //token 改变
    public static let notiFirstLogin            = "noti_firstLogin"           //首次登录
    
    public static let notiGoogleLogin            = "noti_notiGoogleLogin"     //登录

    
    public static let notiUpdateResetRootView   = "noti_updateResetRootView"  //重置根视图

    public static let notiRefreshDataView        = "noti_refreshDataView"  //刷新数据


}


// MARK: - DataClass
struct YWSplashScreenList: Codable {
    let dataList: [SplashscreenList]?
    
    enum CodingKeys: String, CodingKey {
        case dataList = "dataList"
    }
}
// MARK: - SplashscreenList
struct SplashscreenList: Codable {

    
    let bannerID: Int?
    let adType: Int?
    let adName: String?
    let adPos: Int?
    let pictureURL: String?
  //  let jumpURL: String?
    var jumpType: String?
    let invalidTime: String?
    
    var jumpURL: String? {
        get {
            return self.originJumpURL
        }
    }
    
    let originJumpURL, newsID, tag: String?

    enum CodingKeys: String, CodingKey {
        case bannerID = "id"
        case adType = "type"
        case adName = "advertiseName"
        case adPos = "priority"
        case pictureURL = "img"
        case jumpType = "redirectMethod"
        case invalidTime = "endDate"
        case originJumpURL = "redirectPosition"
        case newsID,tag
    }
}
