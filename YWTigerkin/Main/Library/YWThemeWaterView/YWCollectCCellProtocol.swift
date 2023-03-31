//
//  YWCollectCCellProtocol.swift
//  YWTigerkin
//
//  Created by odd on 3/26/23.
//

import Foundation

protocol YWCollectionCellDelegate:NSObjectProtocol {
    
}

protocol YWCollectCCellProtocol:NSObjectProtocol {
    var model:YWCollectionCellModelProtocol? { get set}
    var delegate:YWCollectionCellDelegate? { get set }
    //var channelId:String {get}
}
