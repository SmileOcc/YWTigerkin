//
//  YWAccountCenterModel.swift
//  YWTigerkin
//
//  Created by odd on 8/14/23.
//

import UIKit

enum YWAccountCenterType: Int {
    case all = 0
    case hot
    case pick
    
    var title:String {
        switch self {
        case .all:
            return "全部"
        case .hot:
            return "热门"
        case .pick:
            return "精选"
        }
    }
}

class YWAccountCenterModel: NSObject {

}

struct YWAccountCenterMenuModel {
    var title:String?
    var id:String?
    
}
