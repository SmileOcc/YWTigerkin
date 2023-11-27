//
//  YWAddressModel.swift
//  YWTigerkin
//
//  Created by odd on 11/27/23.
//

import UIKit

class YWAddressModel: YWBaseModel {
    var id:String = ""
    var area:String = ""
    var address:String = ""
    var userName:String = ""
    var userPhone:String = ""
    
    var isDefault:Bool = false
    var isVaild:Bool = true
    var isSelected:Bool = false
    
    //标签
    var labs:[String] = []
    
    var addressH:CGFloat = 0.0
    var contentH:CGFloat = 80.0
}

