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
    case AR = 0x06
    case HE = 0x07
    case unknown
    
    var identifier: String {
        switch self {
        case .CN, .unknown:
            return "zh-Hans"
        case .HK:
            return "zh-HK"
        case .EN:
            return "en"
        default:
            return "zh-Hans"
        }
    }
    
    var title: String {
        switch self {
        case .CN, .unknown:
            return "中文"
        case .HK:
            return "繁体"
        case .EN:
            return "EN"
        default:
            return "中文"
        }
    }
    
}

extension YWLanguageType: Codable {
    public init(from decoder: Decoder) throws {
        self = try YWLanguageType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

var bundle:Bundle?

func YWLanguageTool(_ key: String) -> String {
    YWLanguageUtility.kLang(key: key)
}

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
