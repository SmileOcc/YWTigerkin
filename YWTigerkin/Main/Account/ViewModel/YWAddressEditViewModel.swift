//
//  YWAddressEditViewModel.swift
//  YWTigerkin
//
//  Created by odd on 11/27/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWAddressEditViewModel: HUDServicesViewModel , HasDisposeBag  {
    typealias Services = AppServices
    
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    var navigator: YWNavigatorServicesType!
    
    let successSubject = PublishSubject<Bool>()
    let disposebag = DisposeBag()

    var datas:[YWAddressItemEditModel] = []
    
    var services: Services! {
        didSet {
            
        }
    }
    
    func requestData() {
        self.hudSubject.onNext(.loading(YWConstant.requestLoading, false))
        for i in 0...5 {
            let model = YWAddressItemEditModel()
            model.title = "其他"
            model.subDesc = "描述"
            if i == 0 {
                model.title = "用户名"
                model.itemType = .name
            } else if i == 1 {
                model.title = "手机号"
                model.itemType = .phone
            } else if i == 2 {
                model.title = "地区"
                model.itemType = .addressArea
            } else if i == 3 {
                model.title = "详细地址"
                model.itemType = .addressDetail
            } else if i == 4 {
                model.title = "设置默认"
                model.itemType = .setDefault
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
