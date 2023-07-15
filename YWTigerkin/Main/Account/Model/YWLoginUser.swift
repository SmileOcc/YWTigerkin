//
//  YWLoginUser.swift
//  YWTigerkin
//
//  Created by odd on 7/15/23.
//

import Foundation

struct YWLoginUser: Codable {
    
    var nickName: String?
    var avatar: String?
    var userId: String?
    var token: String?
    var phone: String?
    var appfirstLogin: Bool?
    
    enum CodingKeys: String, CodingKey {

        case nickName, avatar, userId, token
        case phone = "mobile"
        case appfirstLogin
    }
}
