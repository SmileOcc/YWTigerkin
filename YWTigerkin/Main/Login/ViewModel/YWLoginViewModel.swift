//
//  YWLoginViewModel.swift
//  YWTigerkin
//
//  Created by odd on 7/22/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

public enum YWThirdLoginType: Int {
    case weChat = 1
    case weibo = 2
    case google = 3
    case faceBook = 4
    case apple = 6
    case line = 7
}


public enum YWAccountType:String{
    case email = "email"
    case mobile = "mobile"
}

class YWLoginViewModel: HUDServicesViewModel , HasDisposeBag  {
    typealias Services = HasYWLoginService
    
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    var navigator: YWNavigatorServicesType!
    
//    var loginResponse: HCResultResponse<JSONAny>?
    var loginResponse: YWResultResponse<YWLoginUser>?

    let accountSubject = PublishSubject<Bool>()
    let disposebag = DisposeBag()
    
    var isThirdLogin:Bool = false
    //第三方登录
    var accessToken = "" //三方token，微信、微博、谷歌、facebook同一个
    var openId = "" //微信openId
    var thirdLoginType = YWThirdLoginType.weChat //1:微信、2:微博、3:谷歌、4:facebook 6.apple
    var appleParams: [String: Any] = [:]
    var appleUserId = ""
    var lineUserId = ""
    
    //登录注册广告
    var adResponse: YWResultResponse<YWUserBanner>?
    let adListRelay = BehaviorRelay<[BannerList]>(value: [])
    
    let loginSuccessSubject = PublishSubject<Bool>()//登录成功回调
    let unRegisteredSubject = PublishSubject<String>()//没有注册回调
    let fillPhoneSubject = PublishSubject<[String]>()//填充手机号
    let lockedSubject = PublishSubject<String>()//锁住 //密码错误次数过多账号已锁定，请%d分钟后重新登录或找回密码
    let freezeSubject = PublishSubject<String>()//冻结 //手机账户被冻结
    let unsetLoginPwdSubject = PublishSubject<String>()//未设置登录密码
    let hasActivateSubject = PublishSubject<String>() //已激活--预注册
    let thirdLoginUnbindPhoneSubject = PublishSubject<String>() //第三方登录没有绑定手机号
    
    var accoutType = BehaviorRelay<YWAccountType>(value: .email)
    var mobile = BehaviorRelay<String>(value: "")
    var email = BehaviorRelay<String>(value: "")
    
    var mPwd = BehaviorRelay<String>(value: "")
    var ePwd = BehaviorRelay<String>(value: "")
    var areaCode = BehaviorRelay<String>(value: YWUserManager.shared().defCode)
    
    
    
    var mobileHidden = PublishSubject<Bool>()
    var emailHidden = PublishSubject<Bool>()
    var mUsernameValid : Observable<Bool>?
    var mPasswordValid : Observable<Bool>?
    var mEverythingValid : Observable<Bool>?
    var eUsernameValid : Observable<Bool>?
    var ePasswordValid : Observable<Bool>?
    var eEverythingValid : Observable<Bool>?
    
    var loginCallBack: (([String: Any])->Void)?

    var cancelCallBack: (() -> Void)?
    weak var vc: UIViewController?
    
    var services: Services! {
        didSet {
            loginResponse = {[weak self] (response) in
                guard let `self` = self else {return}
                self.hudSubject.onNext(.hide)
                switch response {
                    case .success(let result, let code):
                    switch code {
                    case .success?:
                        
                        let userInfo = result.result

                        func setUserInfo(){
                            if let ccc = userInfo {
                            }
                            print("=================")

                            YWUserManager.setLoginInfo(user: userInfo)
                            YWUserManager.shared().defCode = self.areaCode.value
                            let mmkv = MMKV.default()
                            mmkv?.set(self.areaCode.value, forKey: YWUserManager.YWDefCode)
                            mmkv?.set(self.accoutType.value.rawValue,forKey: YWUserManager.YWLoginType)
                            //通知 更新用户信息
                            NotificationCenter.default.post(name: NSNotification.Name(YWUserManager.notiUpdateUserInfo), object: nil)
                            
                            self.loginSuccessSubject.onNext(true)
                            if let loginCallBack = self.loginCallBack {
                                loginCallBack(YWUserManager.userInfo)
                            }
                        }
                        
                        setUserInfo()
                    default:
                        if let msg = result.message {
                            self.hudSubject.onNext(.error(msg, false))
                            
                        }
                    }
                case .failed(_):
                    print("error")
                    YWProgressHUD.showSuccess(YWLanguageUtility.kLang(key: "common_net_error"))
                    self.hudSubject.onNext(.error(YWConstant.requestNetError, false))
                }
            
                
            }
        }
    }
        
    
    init(callBack: (([String: Any])->Void)?, cancelCallBack: (() -> Void)? = nil, vc: UIViewController?,mobile:String="",email:String="",accoutType:YWAccountType=YWAccountType.mobile,areacode:String=YWUserManager.shared().defCode) {
        self.loginCallBack = callBack
        self.cancelCallBack = cancelCallBack
        self.vc = vc
       
        self.accoutType.subscribe(onNext:{ [weak self]type in
            if type == .email {
                self?.mobileHidden.onNext(true)
                self?.emailHidden.onNext(false)
            }else {
                self?.mobileHidden.onNext(false)
                self?.emailHidden.onNext(true)
            }
        }).disposed(by: disposebag)
        
        self.mobile.accept(mobile)
        self.email.accept(email)
        self.accoutType.accept(accoutType)
        self.areaCode.accept(areacode)
        self.handleEmailInput()
        self.handleMobInput()
    }
    
    func handleMobInput(){
        self.mUsernameValid = mobile.asObservable()
                    .map { $0.count > 0 }
                    .share(replay: 1)
        self.mPasswordValid = mPwd.asObservable()
                    .map { $0.count > 0 }
                    .share(replay: 1)
        self.mEverythingValid = Observable.combineLatest(mUsernameValid!, mPasswordValid!) { $0 && $1 }
                    .share(replay: 1)
    }
    
    func handleEmailInput() {
        self.eUsernameValid = email.asObservable()
                    .map { ($0.isValidEmail) && $0.count > 0}
                    .share(replay: 1)
        self.ePasswordValid = ePwd.asObservable()
                    .map { $0.count > 0 }
                    .share(replay: 1)
        self.eEverythingValid = Observable.combineLatest(eUsernameValid!, ePasswordValid!) { $0 && $1 }
                    .share(replay: 1)
    }
    
    func handelAccountChanage(title:String)  {
        if title == YWLanguageUtility.kLang(key: "mobile_acount") {
            accoutType.accept(.mobile)
        }else{
            accoutType.accept(.email)
        }
    }
    
    func gotoRegist(autoSendCaptcha:Bool) {
        
    }
    
    func findPassWord(currentVC:UIViewController?) {
        
        self.mPwd.accept("")
        self.ePwd.accept("")
    }
    
    func bindAccount()  {
        
    }
    
    func accountLogin()  {
//      hudSubject?.onNext(.loading(nil, false))
//      services.loginService.request(.login("",email.value, YWUserManager.safeDecrypt(string: ePwd.value)), response:loginResponse).disposed(by: disposebag)
        
        hudSubject?.onNext(.loading(nil, false))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.hudSubject.onNext(.hide)
            self.testLogin()
            self.accountSubject.onNext(true)
        })
    }
    
    func mobileLogin()  {
//        hudSubject?.onNext(.loading(nil, false))
//        services.loginService.request(.login(areaCode.value, YWUserManager.safeDecrypt(string: mobile.value),YWUserManager.safeDecrypt(string: mPwd.value)), response: loginResponse).disposed(by: disposebag)
        
        hudSubject?.onNext(.loading(nil, false))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.hudSubject.onNext(.hide)
            self.testLogin()
            self.accountSubject.onNext(true)
        })
    }
    
    func testLogin() {
        
        var userInfo = YWLoginUser()
        userInfo.nickName = "佚名"
        userInfo.token = "123456"
        userInfo.phone = "13123123421"
        userInfo.avatar = ""
        userInfo.userId = "12213iodsfojodf"
        
        YWUserManager.setLoginInfo(user: userInfo)
        YWUserManager.shared().defCode = self.areaCode.value
        let mmkv = MMKV.default()
        mmkv?.set(self.areaCode.value, forKey: YWUserManager.YWDefCode)
        mmkv?.set(self.accoutType.value.rawValue,forKey: YWUserManager.YWLoginType)
        //通知 更新用户信息
        NotificationCenter.default.post(name: NSNotification.Name(YWUserManager.notiUpdateUserInfo), object: nil)
        
        self.loginSuccessSubject.onNext(true)
        if let loginCallBack = self.loginCallBack {
            loginCallBack(YWUserManager.userInfo)
        }
    }
    
}
