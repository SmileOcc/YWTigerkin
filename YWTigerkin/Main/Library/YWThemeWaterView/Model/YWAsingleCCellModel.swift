//
//  YWAsingleCCellModel.swift
//  YWTigerkin
//
//  Created by odd on 4/2/23.
//

import UIKit

class YWAsingleCCellModel: NSObject,YWCollectionCellModelProtocol {
    
    var dataSource: Any?
    
    var bgColor: String?
    
    func customerSize() -> CGSize {
        self.size ?? CGSize.zero
    }
    
    func reuseIdentifier() -> String {
        "AsingleID"
    }
    
    static func reuseIdentifier() -> String {
        "AsingleID"
    }
    

    var size:CGSize?
    var customerBgColor:UIColor?
    
    var leftSpace = 16.0
}
