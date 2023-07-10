//
//  YWSearchAPI.swift
//  YWTigerkin
//
//  Created by odd on 3/3/23.
//

import Foundation
import Moya

let searchProvider = MoyaProvider<YWSearchAPI>(requestClosure: requestTimeoutClosure, session : YWMoyaConfig.session(), plugins: [YWNetworkLoggerPlugin(verbose: true)])

public enum YWSearchAPI {
    
    case changePwd (_ oldPassword: String, password: String)
    
    /*//获取手机验证码(默认用户手机号)
     type:业务类型（201 重置交易密码短信 202 更换手机号 203 设置登录密码）
     token-send-phone-captcha/v1  */
    case tokenSendCaptcha (_ type: NSInteger)
    /*校验更换手机号验证码
     verify-replace-phone/v1 */
    case verifyChangePhone (_ captcha: String, _ pwd: String)
    /*更换手机号
     replace-phone/v1 */
    case changePhone (_ captcha: String, _ phone: String, _ areaCode: String)
    /*更换邮箱
     replace-email/v1 */
    case changeEmail (_ email: String, _ pwd: String)
    
    /*获取当前用户信息
     get-current-user/v1 */
    case getCurrentUser
    
    
    
}

extension YWSearchAPI: YWTargetType {
    
    public var requestCache: Bool? {
        true
    }
    public var path: String {
        switch self {
       
        case .changePwd:
             return servicePath + "update-login-password/v1"
        
        case .tokenSendCaptcha:
            return servicePath + "token-send-phone-captcha/v1"
            /*校验更换手机号验证码
             verify-replace-phone/v1 */
        case .verifyChangePhone:
            return servicePath + "verify-replace-phone/v1"
            /*更换手机号
             replace-phone/v1 */
        case .changePhone:
            return servicePath + "replace-phone/v1"
            /*更换邮箱
             replace-email/v1 */
        case .changeEmail:
            return servicePath + "replace-email/v1"
        
        case .getCurrentUser:
            return servicePath + "get-current-user/v1"
        }
    }
    
    public var task: Task {
        var params: [String: Any] = [:]
        switch self {
        
        case .changePwd(let oldPassword, let password):
            params["oldPassword"] = oldPassword
            params["password"] = password
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        
        case .tokenSendCaptcha(let type):
            /*//获取手机验证码(默认用户手机号)
             type:业务类型（201 重置交易密码短信 202 更换手机号 203 设置登录密码）
             token-send-phone-captcha/v1  */
            params["type"] = NSNumber(integerLiteral: type)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .verifyChangePhone(let captcha, let pwd):
            /*校验更换手机号验证码
             verify-replace-phone/v1 */
            params["captcha"] = captcha
            params["password"] = pwd
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .changePhone(let captcha, let phone, let areaCode):
            /*更换手机号
             replace-phone/v1 */
            params["captcha"] = captcha
            params["phoneNumber"] = phone
            params["areaCode"] = areaCode
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .changeEmail(let email, let pwd):
            /*更换邮箱
             replace-email/v1 */
            params["password"] = pwd
            params["email"] = email
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        
        /*获取当前用户信息
         get-current-user/v1 */
        case .getCurrentUser:
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        
        default:
            return .requestPlain
        }
    }
    
    public var baseURL: URL {
        return URL(string: YWUrlRouterConstant.hzBaseUrl())!

    }
    
    public var requestType: YWRequestType {
        return .hzRequest
        
    }
    
    public var servicePath: String {
        switch self {
        case
            .tokenSendCaptcha,
            .verifyChangePhone:
            return "/user-server/api/"
        default:
            return "/user-server-do/api/"
        }
    }
    
    public var method: Moya.Method {
        switch self {

        case .changePhone,
             .verifyChangePhone:
            return .put
        default:
            return .post
        }
    }
    
    public var headers: [String : String]? {
        var headers = yw_headers
        if let contentType = contentType {
            headers["Content-Type"] = contentType
        }
        
        
        return headers
    }
    
    public var contentType: String? {
        switch self {
        case .tokenSendCaptcha,
             .changeEmail:
            return "application/x-www-form-urlencoded"
        default:
            return "application/json"
        }
    }
    
    public var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
}
