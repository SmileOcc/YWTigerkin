//
//  YWOtherTestViewModel.swift
//  YWTigerkin
//
//  Created by odd on 6/18/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWOtherTestViewModel: HUDServicesViewModel , HasDisposeBag  {
    typealias Services = AppServices
    
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    var navigator: YWNavigatorServicesType!
    
//    var loginResponse: HCResultResponse<JSONAny>?
    var accountResponse: YWResultResponse<YWHomeModel>?
    let accountSubject = PublishSubject<Bool>()
    let disposebag = DisposeBag()

    var datas:[YWAccountItemModel] = []
    
    var services: Services! {
        didSet {
            accountResponse = {[weak self] (response) in
                guard let `self` = self else {return}
                self.hudSubject.onNext(.hide)
                switch response {
                    case .success(let result, let code):
                    switch code {
                    case .success?:
                        
                        let userInfo = result.result

                        func setUserInfo(){
                            if let ccc = userInfo {
                                print("name: \(ccc.banner)")
                            }
                            print("=================")

                            print("=================")
                        }
                        
                        setUserInfo()
                        self.accountSubject.onNext(true)
                    default:
                        if let msg = result.message {
                            self.hudSubject.onNext(.error(msg, false))
                            
                        }
                    }
                case .failed(_):
                    print("error")
                    //YXProgressHUD.showSuccess(YXLanguageUtility.kLang(key: "common_net_error"))
                    self.hudSubject.onNext(.error(YWConstant.requestNetError, false))
                }
            
                
            }
        }
    }
    
    func requestData() {
        self.hudSubject.onNext(.loading(YWConstant.requestLoading, false))
        for i in 0...5 {
            let model = YWAccountItemModel()
            model.title = "其他"
            model.imgName = "settings"
            model.id = "\(i)"
            if i == 0 {
                model.title = "Apple Pay"
            } else if i == 1 {
                model.title = "视频横竖屏"
            } else if i == 2 {
                model.title = "抖音模式"
            } else if i == 3 {
                model.title = "活动"
                model.desc = "最新活动"
            } else if i == 4 {
                model.title = "版本"
                model.desc = "v_\(YWConstant.appVersion ?? "")"
            } else if i == 5 {
                model.title = "网页"
            }
            self.datas.append(model)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.hudSubject.onNext(.hide)
            self.accountSubject.onNext(true)
        })
    }
    
    func testRequest() {
        
        
//        self.services.loginService.requesttttt(.testRequest("1"), response: loginResponse)

//        self.services.loginService.request(.testRequest("1"), response: accountResponse).disposed(by: disposebag)
    }
}
