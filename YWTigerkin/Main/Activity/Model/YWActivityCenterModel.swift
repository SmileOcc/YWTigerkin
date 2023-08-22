//
//  YWActivityCenterModel.swift
//  YWTigerkin
//
//  Created by odd on 8/17/23.
//

import UIKit
enum YWActivityCenterType: Int {
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

class YWActivityCenterModel: NSObject {

}

struct YWActivityCenterMenuModel {
    var title:String?
    var id:String?
    
}
