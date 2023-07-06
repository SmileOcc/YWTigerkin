//
//  YWCommonService.swift
//  YWTigerkin
//
//  Created by odd on 7/1/23.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

protocol HasYWCommonService {
    var commonService: YWCommonService { get }
}

class YWCommonService: YWRequestable {
    typealias API = YWCommonAPI
    
    var networking: MoyaProvider<API> {
        commonProvider
    }
}
