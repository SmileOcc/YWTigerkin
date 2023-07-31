//
//  YWCollectionCellModelProtocol.swift
//  YWTigerkin
//
//  Created by odd on 3/26/23.
//

import Foundation

@objc protocol YWCollectionCellModelProtocol:NSObjectProtocol {

    var dataSource: Any? { get  }
    var bgColor: String? { get }
    
    /**
     *  默认 CGSizeZero
     *
     *  如果设置了该属性，算法中就以此为标准计算
     */
    @objc func customerSize() -> CGSize
    
    @objc func reuseIdentifier() -> String
    
    @objc static func reuseIdentifier() -> String
}
