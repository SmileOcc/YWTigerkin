//
//  YWSettingViewModel.swift
//  YWTigerkin
//
//  Created by odd on 7/31/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWSettingViewModel: HUDServicesViewModel , HasDisposeBag  {
    typealias Services = AppServices
    
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    var navigator: YWNavigatorServicesType!
    
    var language: YWLanguageType = .CN

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
        for i in 0...5 {
            let model = YWAccountItemModel()
            model.title = "其他"
            model.imgName = "settings"
            model.id = "\(i)"
            if i == 0 {
                let lang = YWUserManager.curLanguage()
                model.title = "语言设置(点击切换)"
                model.desc = "\(lang.title)"
            } else if i == 1 {
                model.title = "版本信息"
                model.desc = "最新版本"
            }
            self.datas.append(model)
        }
        
        self.accountSubject.onNext(true)
    }
    
    func testRequest() {
        
        
//        self.services.loginService.requesttttt(.testRequest("1"), response: loginResponse)

//        self.services.loginService.request(.testRequest("1"), response: accountResponse).disposed(by: disposebag)
    }
}
