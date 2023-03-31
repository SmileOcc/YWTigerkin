//
//  YWThemesCCell.swift
//  YWTigerkin
//
//  Created by odd on 3/26/23.
//

import UIKit

class YWThemesCCell: UICollectionViewCell,YWCollectCCellProtocol {
    
    var model: YWCollectionCellModelProtocol? {
        didSet {
            if let tModel = model as? YWAdvsEventsModel {
                
            }
        }
    }
    
    var delegate: YWCollectionCellDelegate?
}
