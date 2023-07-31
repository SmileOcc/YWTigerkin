//
//  YWLoginService.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

protocol HasYWLoginService {
    var loginService: YWLoginService { get }
}

class YWLoginService: YWRequestable {
    typealias API = YWLoginAPI
    
    var networking: MoyaProvider<API> {
        loginProvider
    }
}
