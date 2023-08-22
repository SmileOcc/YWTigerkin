//
//  YWOrderItemListViewModel.swift
//  YWTigerkin
//
//  Created by odd on 8/12/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWOrderItemListViewModel: HUDServicesViewModel,HasDisposeBag {
    
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    var navigator: YWNavigatorServicesType!

    typealias Services = HasYWSearchService
    
    
    var services: Services! {
        didSet {
            
        }
    }
}
