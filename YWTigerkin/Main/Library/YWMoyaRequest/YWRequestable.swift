//
//  YWRequestable.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import Foundation
import Moya
import RxSwift

public enum YWResponseType<T: Codable> {
    case success(_ result: YWResult<T>, _ code: YWResponseCode?)
    case failed(_ error: Error)
}

public typealias YWResultResponse<T: Codable> = ((YWResponseType<T>) -> Void)

public protocol YWRequestable {
    associatedtype API: YWTargetType

    var networking: MoyaProvider<API> { get }
}

public let TokenFailureNotification = "TokenFailureNotification"

public extension YWRequestable {
//    func request<T: Codable>(_ target: API, response: YWResultResponse<T>?) -> Disposable {
//
//        return networking.rx.request(target).map(YWResult<T>.self).subscribe(onSuccess: { (result) in
//
//            if YWResponseCode(rawValue: result.code) == .accountTokenFailure {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TokenFailureNotification), object: nil)
//            } else {
//                response?(.success(result, YWResponseCode(rawValue: result.code)))
//            }
//
//            if result.code != 0 {
//                if result.code != 806901, result.code != 806916, result.code != 800002 && result.code != 800000 {
//                    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
////                    YWRealLogger.shareInstance.realLog(type: "ApiError", name: "接口Error", url: url, code: "\(result.code)", desc: result.msg, extend_msg: nil)
//                }
//            }
//
//        }, onFailure: { (error) in
//            if let urlError = error as? URLError, urlError.code.rawValue == NSURLErrorTimedOut, let host = target.baseURL.host {
//                YWUrlRouterConstant.ipAddressStatus[host] = false
//            }
//            if let urlError = error as? URLError, urlError.code.rawValue != NSURLErrorNotConnectedToInternet {
//                let code = "\(urlError.code.rawValue)"
//                var desc = urlError.localizedDescription
//                // 4xx 或 5xx不上报body
//                if code.hasPrefix("4") || code.hasPrefix("5") {
//                    desc = ""
//                }
////                YWRealLogger.shareInstance.realLog(type: "ApiError", name: "接口Error", url: "\(target.baseURL)\(target.path)", code: code, desc: desc, extend_msg: nil)
//            } else if !(error is URLError) {
////                YWRealLogger.shareInstance.realLog(type: "ApiError", name: "接口Error", url: "\(target.baseURL)\(target.path)", code: "-1", desc: error.localizedDescription, extend_msg: nil)
//            }
//
//            response?(.failed(error))
//        })
//    }
    
    func request<T: Codable>(_ target: API, response: YWResultResponse<T>?) -> Disposable {
        
        
        return networking.rx.request(target).map(YWResult<T>.self).subscribe(onSuccess: { (result) in
            
            print("restul: ====ccccc \(result)")
            if YWResponseCode(rawValue: result.statusCode) == .accountTokenFailure {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TokenFailureNotification), object: nil)
            } else {
                response?(.success(result, YWResponseCode(rawValue: result.statusCode)))
            }
            
            if result.statusCode != 0 {
//                if result.statusCode != 806901, result.code != 806916, result.code != 800002 && result.code != 800000 {
//                    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
//                    //YXRealLogger.shareInstance.realLog(type: "ApiError", name: "接口Error", url: url, code: "\(result.code)", desc: result.msg, extend_msg: nil)
//                }
            }
            
        }, onFailure: { (error) in
            if let urlError = error as? URLError, urlError.code.rawValue == NSURLErrorTimedOut, let host = target.baseURL.host {
                YWUrlRouterConstant.ipAddressStatus[host] = false
            }
            if let urlError = error as? URLError, urlError.code.rawValue != NSURLErrorNotConnectedToInternet {
                let code = "\(urlError.code.rawValue)"
                var desc = urlError.localizedDescription
                // 4xx 或 5xx不上报body
                if code.hasPrefix("4") || code.hasPrefix("5") {
                    desc = ""
                }
//                YXRealLogger.shareInstance.realLog(type: "ApiError", name: "接口Error", url: "\(target.baseURL)\(target.path)", code: code, desc: desc, extend_msg: nil)
            } else if !(error is URLError) {
//                YXRealLogger.shareInstance.realLog(type: "ApiError", name: "接口Error", url: "\(target.baseURL)\(target.path)", code: "-1", desc: error.localizedDescription, extend_msg: nil)
            }
            
            response?(.failed(error))
        })
    }
}


