//
//  YWLoginCtrl.swift
//  YWTigerkin
//
//  Created by odd on 7/22/23.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import AuthenticationServices

class YWLoginCtrl: YWBaseViewController , HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWLoginViewModel!

    private var scrollView :UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    
    lazy var headTitleView : YXLoginTitleView = {
        if self.viewModel.accoutType.value == .mobile{
        let view = YXLoginTitleView.init(mainTitle: YWLanguageUtility.kLang(key: "mobile_acount"), subTitle: "\(YWLanguageUtility.kLang(key: "acount_title"))")
            return view
        }else {
            let view = YXLoginTitleView.init(mainTitle: YWLanguageUtility.kLang(key: "acount_title"), subTitle: "\(YWLanguageUtility.kLang(key: "mobile_acount"))")
                return view
        }
    }()
    
    lazy var mobileSignInView : YWSignInView = {
        let view = YWSignInView.init(type: .mobile)
        let phoneTextField:YWPhoneTextField = view.acountField as! YWPhoneTextField
        phoneTextField.areaCodeLale.text = "+\(self.viewModel.areaCode.value)"
        return view
    }()
    
    lazy var emailSignInView : YWSignInView = {
        let view = YWSignInView.init(type: .email)
        return view
    }()
    
    lazy var quickSignInView : YWQuickLoginView = {
        let view = YWQuickLoginView.init(hasWeChat: true)
        ///提审需要,暂时隐藏第三方入口
        //view.isHidden = true
        return view
    }()
    
    lazy var declareView : YWDeclareView = {
        let view = YWDeclareView.init(frame: .zero)
        return view
    }()
    
    
    lazy var registBtn : UIButton = {
        let goRegistBtn = UIButton()
        goRegistBtn.setTitle(YWLanguageUtility.kLang(key: "sign_up"), for: .normal)
        goRegistBtn.setTitleColor(YWThemesColors.col_themeColor, for: .normal)
        goRegistBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        goRegistBtn.layer.borderColor = YWThemesColors.col_themeColor.cgColor
        goRegistBtn.layer.borderWidth = 1
        goRegistBtn.layer.cornerRadius = 4
        return goRegistBtn
    }()
    
    lazy var bannerView: YWLoginAdvView = {
        let view = YWLoginAdvView()
        view.isHidden = true
        view.didCloseBlock = {[weak self] in
            guard let strongSelf = self else { return }
//            strongSelf.showBanner(false)
        }
        view.tapBannerBlock = {[weak self] (index) in
            guard let strongSelf = self else { return }

            if index < strongSelf.viewModel.adListRelay.value.count {
                let model = strongSelf.viewModel.adListRelay.value[index]
                let url = model.jumpURL ?? ""
                if url.count > 0 {
//                    YWBannerManager.goto(withBanner: model, navigator: strongSelf.viewModel.navigator)
                }
            }
        }
        return view
    }()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sh_prefersNavigationBarHidden = true
        self.sh_interactivePopDisabled = true
        
        self.view.backgroundColor = UIColor.white
        initUI()

        bindViewModel()
        viewModelResponse()
        bindHUD()

    }
    
    func initUI() {
        //self.baseNavBar.isHidden = false
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(headTitleView)
        scrollView.addSubview(mobileSignInView)
        scrollView.addSubview(emailSignInView)
        scrollView.addSubview(quickSignInView)
        scrollView.addSubview(declareView)
        scrollView.addSubview(registBtn)
                
        
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.right.bottom.equalTo(self.view)
        }
        
        headTitleView.snp.makeConstraints { (make) in
            make.top.equalTo(24)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(60)
        }
        
        mobileSignInView.snp.makeConstraints { (make) in
            make.top.equalTo(headTitleView.snp.bottom).offset(40)
            make.left.width.equalToSuperview()
            make.height.equalTo(264)

        }
        
        emailSignInView.snp.makeConstraints { (make) in
            make.size.equalTo(mobileSignInView)
            make.top.left.equalTo(mobileSignInView)
        }
        
        registBtn.snp.makeConstraints { (make) in
            make.height.equalTo(48)
            make.top.equalTo(emailSignInView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(30)
            make.right.equalTo(view.snp.right).offset(-30)
        }

        //提审需要暂时隐藏
        quickSignInView.snp.makeConstraints { (make) in
            make.top.equalTo(registBtn.snp.bottom).offset(24)
            make.height.equalTo(80)
//            make.top.equalTo(registBtn.snp.bottom).offset(0)
//            make.height.equalTo(0)
            make.width.equalToSuperview()
        }

        declareView.snp.makeConstraints { (make) in
            make.top.equalTo(quickSignInView.snp.bottom).offset(16)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(36)
            if YWConstant.screenHeight < 812 {
                make.bottom.equalTo(self.scrollView.snp.bottom).offset(-20)
            } else {
                make.bottom.equalTo(self.scrollView.snp.bottom).offset(-42)
            }
        }
        
        scrollView.addSubview(bannerView)
        bannerView.isHidden = true
//        bannerView.snp.makeConstraints { make in
//            make.left.equalTo(scrollView.snp.left).offset(12)
//            make.right.equalTo(self.view.snp.right).offset(-12)
//
//            make.top.equalTo(declareView.snp.bottom).offset(0)
//            if YWConstant.screenHeight < 812 {
//                make.bottom.equalTo(self.scrollView.snp.bottom).offset(-20)
//            } else {
//                make.bottom.equalTo(self.scrollView.snp.bottom).offset(-42)
//            }
//            make.height.equalTo(self.bannerView.snp.width).multipliedBy(70.0/350.0)
//        }
        
        if self.viewModel.email.value.count > 0 {
            emailSignInView.acountField.textField.becomeFirstResponder()
        }
        if self.viewModel.mobile.value.count > 0 {
            mobileSignInView.acountField.textField.becomeFirstResponder()
        }
    }
    
  
    @objc func closeBannerAction() {
        self.showBanner(false)
    }
    @objc func showBanner(_ show: Bool) {
        
//        self.bannerView.isHidden = !show
//        if show {
//            bannerView.snp.remakeConstraints { make in
//                make.left.equalTo(scrollView.snp.left).offset(12)
//                make.right.equalTo(self.view.snp.right).offset(-12)
//
//                make.top.equalTo(declareView.snp.bottom).offset(40)
//                 if (YWConstant.screenHeight < 812) {//12 mini
//                    make.bottom.equalTo(self.scrollView.snp.bottom).offset(-20)
//                }  else {
//                    make.bottom.equalTo(self.scrollView.snp.bottom).offset(-42)
//                }
//
//                make.height.equalTo(self.bannerView.snp.width).multipliedBy(70.0/350.0)
//            }
//
//        } else {
//            bannerView.snp.remakeConstraints { make in
//                make.left.equalTo(scrollView.snp.left).offset(12)
//                make.right.equalTo(self.view.snp.right).offset(-12)
//                make.top.equalTo(declareView.snp.bottom).offset(0)
//                if YWConstant.screenHeight < 812 {
//                    make.bottom.equalTo(self.scrollView.snp.bottom).offset(-20)
//                } else {
//                    make.bottom.equalTo(self.scrollView.snp.bottom).offset(-42)
//                }
//                make.height.equalTo(self.bannerView.snp.width).multipliedBy(0)
//            }
//        }
    }
    
    override func viewModelResponse() {
        
        //登錄成功的回調
        viewModel.loginSuccessSubject.subscribe(onNext: { [weak self] success in
            self?.view.endEditing(true)
            YWProgressHUD.showSuccess(YWLanguageUtility.kLang(key: "login_loginSuccess"))
            self?.loginSuccessBack(self?.viewModel.vc, loginCallBack: self?.viewModel.loginCallBack)
            

            
        }).disposed(by: disposeBag)
        
        //密码错误次数过多账号已锁定，请%d分钟后重新登录或找回密码
        viewModel.lockedSubject.subscribe(onNext: { [weak self] msg in
            //self?.showLockedAlert(withMsg: msg)
        }).disposed(by: disposeBag)
        
        //没有注册回调
        viewModel.unRegisteredSubject.subscribe(onNext: { [weak self] msg in
            //self?.unRegisteredAlert(withMsg: msg)
        }).disposed(by: disposeBag)
       
        //第三方登录没有绑定手机号
        viewModel.thirdLoginUnbindPhoneSubject.subscribe(onNext: { [weak self] (msg) in
            guard let `self` = self else {return}
            self.viewModel.bindAccount()
        }).disposed(by: disposeBag)
        
        //adListRelay订阅信号的实现，banner广告展示
        viewModel.adListRelay.asDriver().skip(1).drive(onNext: { [weak self] (adList) in
            guard let `self` = self else {return}

            if adList.count > 0 {
                var adImageUrls = [String]()
                adList.forEach({ (model) in
                    adImageUrls.append(model.pictureURL ?? "")
                })
                self.bannerView.imageURLStringsGroup = adImageUrls
                self.showBanner(true)
            } else {
                self.showBanner(false)
            }

        }).disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        
        self.viewModel.mobile.bind(to: mobileSignInView.acountField.textField.rx.text).disposed(by: disposeBag)
        self.viewModel.email.bind(to: emailSignInView.acountField.textField.rx.text).disposed(by: disposeBag)
        
        mobileSignInView.acountField.textField.rx.text.orEmpty.bind(to: self.viewModel.mobile).disposed(by: disposeBag)
        emailSignInView.acountField.textField.rx.text.orEmpty.bind(to: self.viewModel.email).disposed(by: disposeBag)
        mobileSignInView.passWordField.textField.rx.text.orEmpty.bind(to: self.viewModel.mPwd).disposed(by: disposeBag)
        emailSignInView.passWordField.textField.rx.text.orEmpty.bind(to: self.viewModel.ePwd).disposed(by: disposeBag)

        viewModel.ePwd.bind(to: emailSignInView.passWordField.textField.rx.text).disposed(by: disposeBag)
        viewModel.mPwd.bind(to: mobileSignInView.passWordField.textField.rx.text).disposed(by: disposeBag)
        
        //google调用登录接口
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: YWUserManager.notiGoogleLogin))
            .take(until: self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe(onNext: { [weak self] noti in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.hudSubject.onNext(.hide)
                let success = noti.userInfo?["success"] as? NSNumber ?? 0
                if success.boolValue == true {
                    strongSelf.viewModel.isThirdLogin = true
                    let code = noti.userInfo?["code"] as? String ?? ""
                    
                    strongSelf.viewModel.accessToken = code
                    strongSelf.viewModel.thirdLoginType = .google
                    
                    strongSelf.viewModel.hudSubject?.onNext(.loading(nil, false))
//                    strongSelf.viewModel.services.aggregationService.request(.thirdLogin(code, "", nil, strongSelf.viewModel.thirdLoginType), response: strongSelf.viewModel.loginResponse).disposed(by: strongSelf.disposeBag)
                } else {
                    let msg = noti.userInfo?["msg"] as? String ?? ""
                    YWProgressHUD.showError(msg)
                   // strongSelf.viewModel.hudSubject.onNext(.error(msg, false))
                }
        })
        
        
        let phoneTextField:YWPhoneTextField = self.mobileSignInView.acountField as! YWPhoneTextField
        phoneTextField.areaCodeBtn.rx.tap.subscribe(onNext:{[weak self] in
            //self?.showMoreAreaAlert()
        }).disposed(by: disposeBag)
        
        headTitleView.didChanage = { [weak self] title in
            self?.viewModel.handelAccountChanage(title: title)
        }

        self.viewModel.emailHidden.bind(to: emailSignInView.rx.isHidden).disposed(by: disposeBag)
        self.viewModel.mobileHidden.bind(to: mobileSignInView.rx.isHidden).disposed(by: disposeBag)
        self.viewModel.mEverythingValid?.bind(to: mobileSignInView.signInBtn.rx.isEnabled).disposed(by: disposeBag)
        self.viewModel.eEverythingValid?.bind(to: emailSignInView.signInBtn.rx.isEnabled).disposed(by: disposeBag)
       
        //清除时设置loginBtn.isEnable = false
        mobileSignInView.acountField.clearBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.mobileSignInView.signInBtn.isEnabled = false
        }).disposed(by: disposeBag)
        mobileSignInView.passWordField.clearBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.mobileSignInView.signInBtn.isEnabled = false
        }).disposed(by: disposeBag)
        
        //清除密码输入
        emailSignInView.acountField.clearBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.emailSignInView.signInBtn.isEnabled = false
        }).disposed(by: disposeBag)
        emailSignInView.passWordField.clearBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.emailSignInView.signInBtn.isEnabled = false
        }).disposed(by: disposeBag)
        
        mobileSignInView.fogotPasswordBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.viewModel.findPassWord(currentVC:self)
        }).disposed(by: disposeBag)
        
        emailSignInView.fogotPasswordBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.viewModel.findPassWord(currentVC:self)
        }).disposed(by: disposeBag)
        

        emailSignInView.signInBtn.rx.tap.subscribe(onNext:{[weak self] in
            guard let `self` = self else { return }

            self.viewModel.accountLogin()
        }).disposed(by: disposeBag)
        
        mobileSignInView.signInBtn.rx.tap.subscribe(onNext:{[weak self] in
            guard let `self` = self else { return }

            self.viewModel.mobileLogin()
        }).disposed(by: disposeBag)
        
        registBtn.rx.tap.subscribe(onNext:{[weak self] in
            guard let `self` = self else { return }

            self.viewModel.gotoRegist(autoSendCaptcha: false)
        }).disposed(by: disposeBag)
        
        //MARK: 第三方登录
        quickSignInView.appleBtn.rx.tap.subscribe(onNext:{ [weak self] in

            self?.didAppleIDBtnClicked()
        }).disposed(by: disposeBag)
        
        quickSignInView.weChatBtn.rx.tap.subscribe(onNext:{ [weak self] in

            YWShareSDKHelper.instance.authorize(.typeWechat, callBack: { [weak self] (success, userInfo, _) in
                            guard let strongSelf = self else { return }
                            if success {
                                //隐藏转圈
                                strongSelf.viewModel.hudSubject?.onNext(.loading(nil, false))
                                //请求第三方登录
                                strongSelf.viewModel.isThirdLogin = true
                                if let credential = userInfo?["credential"] as? [AnyHashable : Any],
                                    let rawData = credential["rawData"] as? [AnyHashable : Any],
                                    let access_token = rawData["access_token"] as? String,
                                    let openid = rawData["openid"] as? String {
                                    strongSelf.viewModel.accessToken = access_token
                                    strongSelf.viewModel.openId = openid
                                    strongSelf.viewModel.thirdLoginType = .weChat
//                                    strongSelf.viewModel.services.aggregationService.request(.thirdLogin(access_token, openid, nil, strongSelf.viewModel.thirdLoginType), response: strongSelf.viewModel.loginResponse).disposed(by: strongSelf.disposeBag)
                                }
                            }else {
                                if let _ = userInfo?["error"] {
                                    YWProgressHUD.showError(YWLanguageUtility.kLang(key: "login_auth_failure"))
                                }else {
                                    YWProgressHUD.showError(YWLanguageUtility.kLang(key: "login_auth_cancel"))
                                }
                            }
                        })
        }).disposed(by: disposeBag)
        
        quickSignInView.googleBtn.rx.tap.subscribe(onNext:{ [weak self] in

            self?.viewModel.hudSubject.onNext(.loading("", false))
            //GIDSignIn.sharedInstance().signIn()
            self?.viewModel.hudSubject.onNext(.hide)

            YWProgressHUD.showError(YWLanguageUtility.kLang(key: "login_auth_failure"))
            
        }).disposed(by: disposeBag)
        
        quickSignInView.faceBookBtn.rx.tap.subscribe(onNext:{ [weak self] in

            YWShareSDKHelper.instance.authorize(.typeFacebook, callBack: { [weak self] (success, userInfo, _) in
                guard let strongSelf = self else { return }

                self?.viewModel.hudSubject.onNext(.hide)
                if success {
                    //隐藏转圈
                    strongSelf.viewModel.hudSubject?.onNext(.loading(nil, false))
                    //请求第三方登录
                    strongSelf.viewModel.isThirdLogin = true
//                    if let credential = userInfo?["credential"] as? [AnyHashable : Any],
//                        let rawData = credential["rawData"] as? [AnyHashable : Any],
//                        let access_token = rawData["access_token"] as? String {
//                        strongSelf.viewModel.accessToken = access_token
//                        strongSelf.viewModel.thirdLoginType = .faceBook
//                        strongSelf.viewModel.services.aggregationService.request(.thirdLogin(access_token, "", nil, strongSelf.viewModel.thirdLoginType), response: strongSelf.viewModel.loginResponse).disposed(by: strongSelf.disposeBag)
//                    }
                } else {
                    if let _ = userInfo?["error"] {
                        YWProgressHUD.showError(YWLanguageUtility.kLang(key: "login_auth_failure"))
                    }else {
                        YWProgressHUD.showError(YWLanguageUtility.kLang(key: "login_auth_cancel"))
                    }
                }
            })

        }).disposed(by: disposeBag)
        
        
        quickSignInView.lineBtn.rx.tap.subscribe(onNext:{ [weak self] in

            YWShareSDKHelper.instance.authorize(.typeLine, callBack: { [weak self] (success, userInfo, _) in
                guard let strongSelf = self else { return }

                self?.viewModel.hudSubject.onNext(.hide)
                if success {
                    //隐藏转圈
                    strongSelf.viewModel.hudSubject?.onNext(.loading(nil, false))
                    //请求第三方登录
                    strongSelf.viewModel.isThirdLogin = true
                    if let credential = userInfo?["credential"] as? [AnyHashable : Any],
                        let rawData = credential["rawData"] as? [AnyHashable : Any],
                        let uid = credential["uid"] as? String,
                        let access_token = rawData["accessToken"] as? String {
                        strongSelf.viewModel.accessToken = access_token
                        strongSelf.viewModel.thirdLoginType = .line
                        strongSelf.viewModel.lineUserId = uid
//                        strongSelf.viewModel.services.aggregationService.request(.lineLogin(access_token, uid), response: strongSelf.viewModel.loginResponse).disposed(by: strongSelf.disposeBag)
                    }
                } else {
                    if let _ = userInfo?["error"] {
                        YWProgressHUD.showError(YWLanguageUtility.kLang(key: "login_auth_failure"))
                    }else {
                        YWProgressHUD.showError(YWLanguageUtility.kLang(key: "login_auth_cancel"))
                    }
                }
            })

        }).disposed(by: disposeBag)
        
        declareView.didClickPrivacy = {[weak self]  in
            let dic: [String: Any] = [
                YWWebViewModel.kWebViewModelUrl: YWH5Urls.PRIVACY_POLICY_URL(),
                YWWebViewModel.kWebViewModelCachePolicy : URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            ]
            let webModel = YWWebViewModel(dictionary: dic)
            self?.viewModel.navigator.pushPath(YWModulePaths.webPage.url, context: YWNavigatable(viewModel: webModel), animated: true)
        }
        declareView.didClickService = {[weak self] in
            let dic: [String: Any] = [
                YWWebViewModel.kWebViewModelUrl: YWH5Urls.USER_REGISTRATION_AGREEMENT_URL(),
                YWWebViewModel.kWebViewModelCachePolicy : URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            ]
            
            let webModel = YWWebViewModel(dictionary: dic)
            self?.viewModel.navigator.pushPath(YWModulePaths.webPage.url, context: YWNavigatable(viewModel: webModel), animated: true)
        }
        
        self.viewModel.accoutType.accept(self.viewModel.accoutType.value)
    }
    
}

extension YWLoginCtrl {
    
    @objc func didAppleIDBtnClicked() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let appleIDRequest = appleIDProvider.createRequest()
            appleIDRequest.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [appleIDRequest])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
}


extension YWLoginCtrl: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.windows.last ?? ASPresentationAnchor()
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = appleIDCredential.user
            var nickName: String = ""
            if let familyName = appleIDCredential.fullName?.familyName, let givenName = appleIDCredential.fullName?.givenName {
                nickName = givenName + familyName
                if (familyName as NSString).includeChinese() || (givenName as NSString).includeChinese() {
                    nickName = familyName + givenName
                }
            }
            let email = appleIDCredential.email ?? ""
             
            guard let identityToken = appleIDCredential.identityToken else { return }
            guard let authorizationCode = appleIDCredential.authorizationCode else { return }
            guard let identityTokenStr = String(data: identityToken, encoding: .utf8) else { return }
            guard let authorizationCodeStr = String(data: authorizationCode, encoding: .utf8) else { return }
            
            appleIDLogin(identityTokenStr, authorizationCodeStr, user, email, nickName)
        }
    }
    
    func appleIDLogin(_ identifyToken: String,  _ appleCode: String, _ appleUserId: String, _ email: String, _ nickName: String) {
                        
        let params = ["appleUserID": appleUserId, "email": email, "appleCode": appleCode, "identityToken": identifyToken, "nickName": nickName]
    }
}
