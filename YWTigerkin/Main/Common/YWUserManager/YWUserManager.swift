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

    public static let notiUpdateUUID      = "noti_updateUUID"                 //uuid 改变
    public static let notiLogin           = "noti_login"                      //登录成功
    public static let notiLoginOut        = "noti_loginOut"                   //退出登录
    public static let notiUpdateUserInfo        = "noti_updateUserInfo"       //更新用户信息
    public static let notiUpdateToken           = "noti_updateToken"          //token 改变
    public static let notiFirstLogin            = "noti_firstLogin"           //首次登录
    
    
    static let instance: YWUserManager = YWUserManager()

    class func shared() -> YWUserManager {
        return instance
    }
    
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
        
        NotificationCenter.default.post(name: NSNotification.Name(YWUserManager.notiLogin), object: nil, userInfo: [YWUserManager.notiFirstLogin: YWUserManager.shared().curLoginUser?.appfirstLogin ?? false])
        
        NotificationCenter.default.post(name: NSNotification.Name(YWUserManager.notiUpdateUUID), object: nil)
        
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
        return YWLanguageType(rawValue: Int(curLanguage)) ?? YWLanguageType.EN  //有存储
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
}
