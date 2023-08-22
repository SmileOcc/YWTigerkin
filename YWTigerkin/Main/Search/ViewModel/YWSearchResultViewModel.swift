//
//  YWSearchResultViewModel.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWSearchResultViewModel: HUDServicesViewModel,HasDisposeBag {
    
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    var navigator: YWNavigatorServicesType!

    typealias Services = HasYWSearchService
    
    
    var services: Services! {
        didSet {
            
        }
    }
}
