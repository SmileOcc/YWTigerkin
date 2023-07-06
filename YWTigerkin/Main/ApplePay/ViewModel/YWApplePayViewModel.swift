//
//  YWApplePayViewModel.swift
//  YWTigerkin
//
//  Created by odd on 6/18/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWApplePayViewModel: HUDServicesViewModel ,HasDisposeBag {
    
    var navigator: YWNavigatorServicesType!
    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    typealias Services = HasYWSearchService
    
    
    var services: Services! {
        didSet {
            
        }
    }
}
