//
//  YWCustomerLayoutSectionModuleProtocol.swift
//  YWTigerkin
//
//  Created by odd on 3/26/23.
//

import Foundation

@objc protocol YWCustomerLayoutSectionModuleProtocol:NSObjectProtocol {
    
    @objc var minimumInteritemSpacing:CGFloat { get set}
    
    @objc var sectionDataList:[YWCollectionCellModelProtocol] { get set}
    
    @objc var blockModel:YWThemeBlockModel? {get set}
    
    @objc func childRowsCaclulateFramesWithBottomOffset(_ bottomOffset: CGFloat, _ section: Int) ->[UICollectionViewLayoutAttributes]
    
    @objc func rowNumInSection() -> Int
    
    @objc func sectionBottom() -> CGFloat
    

    
}
