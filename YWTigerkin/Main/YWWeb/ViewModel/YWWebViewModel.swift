//
//  YWWebViewModel.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWWebViewModel:NSObject, HUDServicesViewModel , HasDisposeBag  {
    typealias Services = AppServices
    
    var navigator: YWNavigatorServicesType!
    
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    
    /// webview url key
    @objc static let kWebViewModelUrl = "url"

    /// webview title key
    @objc static let kWebViewModelTitle = "webTitle"

    /// webview titlebar visible key
    @objc static let kWebViewModelTitleBarVisible = "webTitleBarVisible"

    /// webview cache policy
    @objc static let kWebViewModelCachePolicy = "webCachePolicy"
    
//    var loginResponse: HCResultResponse<JSONAny>?
//    var loginResponse: YWResultResponse<YWHomeModel>?

    var homeResponse: YWResultResponse<YWJSONAny>?
    
    let disposebag = DisposeBag()

    var url:String?
    var cachePolicy:URLRequest.CachePolicy = .useProtocolCachePolicy//缓存策略

    init(dictionary: Dictionary<String, Any>) {
        super.init()
        if let url = dictionary[YWWebViewModel.kWebViewModelUrl] {
            self.url = url as? String
        }
        
//        if let webTitle = dictionary[YWWebViewModel.kWebViewModelTitle] {
//            self.webTitle = webTitle as? String
//        }
//
//        if let titleBarVisible = dictionary[YWWebViewModel.kWebViewModelTitleBarVisible] {
//            self.titleBarVisible = titleBarVisible as? Bool ?? true
//        } else {
//            self.titleBarVisible = true
//        }
        
        if let cachePolicy = dictionary[YWWebViewModel.kWebViewModelCachePolicy] {
            self.cachePolicy = cachePolicy as? URLRequest.CachePolicy ?? URLRequest.CachePolicy.useProtocolCachePolicy
        }
    }
    
    var services: Services! {
        didSet {
            homeResponse = {[weak self] (response) in
                guard let `self` = self else {return}
                self.hudSubject.onNext(.hide)
                switch response {
                    case .success(let result, let code):
                    switch code {
                    case .success?:
                        
                        if let resultDic = result.result?.value as? [String:Any] {
                            
                        }
                        let userInfo = result.result

                        func setUserInfo(){
//                            if let ccc = userInfo {
//                                print("name: \(ccc.banner)")
//                            }
                            print("=================")

                            print("=================")
                        }
                        
                        setUserInfo()
                    case .dataCache:
                        print("缓存数据")
                        
                    default:
                        if let msg = result.message {
                            //self.hudSubject.onNext(.error(msg, false))
                            
                        }
                        self.hudSubject.onNext(.error(YWConstant.requestFail, false))
                    }
                case .failed(_):
                    print("error")
                    //YXProgressHUD.showSuccess(YXLanguageUtility.kLang(key: "common_net_error"))
                   // self.hudSubject.onNext(.error(YXLanguageUtility.kLang(key: "common_net_error"), false))
                    
                    self.hudSubject.onNext(.error(YWConstant.requestNetError, false))
                }
            
                
            }
        }
    }
    
    func testRequest() {
        
//        self.services.loginService.requesttttt(.testRequest("1"), response: loginResponse)

        self.services.loginService.request(.testRequest("1"), response: homeResponse).disposed(by: disposebag)
    }
}
