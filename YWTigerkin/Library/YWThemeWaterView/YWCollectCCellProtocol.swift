//
//  YWCollectCCellProtocol.swift
//  YWTigerkin
//
//  Created by odd on 3/26/23.
//

import Foundation

@objc protocol YWCollectionCellDelegate:NSObjectProtocol {
    
}

@objc protocol YWCollectCCellProtocol:NSObjectProtocol {
    @objc var model:YWCollectionCellModelProtocol? { get set}
    @objc weak var delegate:YWCollectionCellDelegate? { get set }
    //var channelId:String {get}
}
