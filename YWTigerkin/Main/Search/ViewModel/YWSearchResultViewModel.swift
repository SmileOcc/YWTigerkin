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

class YWSearchResultViewModel: YWServicesViewModel,HasDisposeBag {

    var navigator: NavigatorServicesType!

    typealias Services = HasYWSearchService
    
    
    var services: Services! {
        didSet {
            
        }
    }
    
    
    func dataRequest(_ loadMore: Bool) {
        
    }
}
