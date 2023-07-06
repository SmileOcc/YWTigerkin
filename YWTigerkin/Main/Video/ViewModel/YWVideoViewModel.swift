//
//  YWVideoViewModel.swift
//  YWTigerkin
//
//  Created by odd on 4/18/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWVideoViewModel: HUDServicesViewModel, HasDisposeBag {

    typealias Services = AppServices
    
    var navigator: YWNavigatorServicesType!

    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    var services: Services! {
        didSet {
        }
    }
}
