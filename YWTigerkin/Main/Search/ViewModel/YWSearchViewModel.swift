//
//  YWSearchViewModel.swift
//  YWTigerkin
//
//  Created by odd on 3/3/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWSearchViewModel: HUDServicesViewModel,HasDisposeBag {
    
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    var navigator: YWNavigatorServicesType!

    typealias Services = HasYWSearchService
    
    
    var services: Services! {
        didSet {
            
        }
    }
}
