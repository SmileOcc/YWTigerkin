//
//  YWUserService.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

protocol HasYWUserService {
    var userService: YWUserService { get }
}

class YWUserService: YWRequestable {

    typealias API = YWUserAPI
    
    var networking: MoyaProvider<API> {
        userProvider
    }
}
