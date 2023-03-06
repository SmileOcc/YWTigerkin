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

class YWSearchViewModel: YWServicesViewModel {
    
    var navigator: NavigatorServicesType!

    typealias Services = HasYWSearchService
    
    
    var services: Services! {
        didSet {
            
        }
    }
}
