//
//  YWLanguageUtility.swift
//  YWTigerkin
//
//  Created by odd on 7/22/23.
//

import UIKit

/// App语言类型定义
///
/// - CN: 简体
/// - HK: 繁体
/// - EN: 英文
@objc enum YWLanguageType: Int {
    case CN = 0x01
    case HK = 0x02
    case EN = 0x03
    case ML = 0x04
    case TH = 0x05
    case unknown
    
    var identifier: String {
        switch self {
        case .CN:
            return "zh-Hans"
        case .HK:
            return "zh-Hant"
        case .EN, .unknown:
            return "en"
        case .ML:
            return "ms"
        case .TH:
            return "th"
        }
    }
    
}

extension YWLanguageType: Codable {
    public init(from decoder: Decoder) throws {
        self = try YWLanguageType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

var bundle:Bundle?

class YWLanguageUtility: NSObject {

    @objc public class func kLang(key: String) -> String {
        NSLocalizedString(key, tableName: "Localizable", bundle: bundle!, value: "", comment: "")
    }
    
    @objc class func initUserLanguage() {
        let language = YWUserManager.curLanguage()
        let path = Bundle.main.path(forResource: language.identifier, ofType: "lproj")
        bundle = Bundle(path: path ?? "")
    }
    
    @objc class func resetUserLanguage(_ type: YWLanguageType) {
        let path = Bundle.main.path(forResource: type.identifier, ofType: "lproj")
        bundle = Bundle(path: path ?? "")
    }
    
    @objc class func identifier() -> String {
        return YWUserManager.curLanguage().identifier
    }
}
