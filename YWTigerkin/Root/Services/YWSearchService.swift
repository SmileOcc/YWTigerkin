//
//  YWSearchService.swift
//  YWTigerkin
//
//  Created by odd on 3/3/23.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

protocol HasYWSearchService {
    var searchService: YWSearchService { get }
}

class YWSearchService: YWRequestable {
    typealias API = YWSearchAPI
    
    var networking: MoyaProvider<API> {
        searchProvider
    }
}
