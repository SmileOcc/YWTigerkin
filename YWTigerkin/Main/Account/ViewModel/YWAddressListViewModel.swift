//
//  YWAddressListViewModel.swift
//  YWTigerkin
//
//  Created by odd on 11/27/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWAddressListViewModel: HUDServicesViewModel , HasDisposeBag  {
    typealias Services = AppServices
    
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    var navigator: YWNavigatorServicesType!
    
    let successSubject = PublishSubject<Bool>()
    let disposebag = DisposeBag()

    var datas:[YWAddressModel] = []
    
    var services: Services! {
        didSet {
            
        }
    }
    
    func requestData() {
        self.hudSubject.onNext(.loading(YWConstant.requestLoading, false))
        for i in 0...5 {
            let model = YWAddressModel()
            model.address = "其他其他其他其他其他其他其他其他其他其他"
            model.userName = "匿名"
            model.userPhone = "131****1234"
            model.id = "\(i)"
            if i == 0 {
                model.userName = "设置"
            } else if i == 1 {
                model.userName = "通知"
            } else if i == 2 {
                model.userName = "分享^"
            } else if i == 3 {
                model.userName = "活动"
            } else if i == 4 {
                model.userName = "版本"
            }
            self.datas.append(model)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.hudSubject.onNext(.hide)
            self.successSubject.onNext(true)
        })
    }
    
    func testRequest() {
        
        

    }
}
