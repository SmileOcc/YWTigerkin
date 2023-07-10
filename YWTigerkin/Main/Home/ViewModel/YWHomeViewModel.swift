//
//  YWHomeViewModel.swift
//  YWTigerkin
//
//  Created by odd on 3/6/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWHomeViewModel: HUDServicesViewModel, HasDisposeBag  {
    typealias Services = AppServices
    
    var navigator: YWNavigatorServicesType!
    
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

//    var loginResponse: HCResultResponse<JSONAny>?
//    var loginResponse: YWResultResponse<YWHomeModel>?

    var homeResponse: YWResultResponse<YWJSONAny>?
    
    let disposebag = DisposeBag()

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
