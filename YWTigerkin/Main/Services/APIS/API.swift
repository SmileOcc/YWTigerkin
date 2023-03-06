//
//  API.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import Moya

let multiProvider = MoyaProvider<MultiTarget>(requestClosure: requestTimeoutClosure, session : YWMoyaConfig.session(), plugins: [YWNetworkLoggerPlugin(verbose: true)])
