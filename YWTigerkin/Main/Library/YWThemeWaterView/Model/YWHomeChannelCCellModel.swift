//
//  YWHomeChannelCCellModel.swift
//  YWTigerkin
//
//  Created by odd on 3/30/23.
//

import UIKit

class YWHomeChannelCCellModel: NSObject,YWCollectionCellModelProtocol {
    var dataSource: Any?
    
    var bgColor: String?
    
    func customerSize() -> CGSize {
        CGSize(width: KSCREEN_WIDTH, height: 44.0)

    }
    
    func reuseIdentifier() -> String {
        "ChannelCellID"
    }
    
    static func reuseIdentifier() -> String {
        "ChannelCellID"
    }
    

}
