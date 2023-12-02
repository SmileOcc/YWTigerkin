//
//  YWAddressItemEditModel.swift
//  YWTigerkin
//
//  Created by odd on 11/27/23.
//

import UIKit

enum YWAddressItemType {
    case name
    case phone
    case addressArea
    case addressDetail
    case setDefault
    case unknow
    
}

class YWAddressItemEditModel: YWBaseModel {

    var itemType:YWAddressItemType = .unknow
    var title:String = ""
    var subDesc:String = ""
    var content:String = ""
    var errorTip:String = ""
    var isShowError:Bool = false
    
    var isArrow:Bool = false
    var isSwitch:Bool = false
    
    var isSetDefault:Bool = false
    
    var contentH:CGFloat = 56.0

}
