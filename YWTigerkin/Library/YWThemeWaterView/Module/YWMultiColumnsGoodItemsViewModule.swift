//
//  YWMultiColumnsGoodItemsViewModule.swift
//  YWTigerkin
//
//  Created by odd on 3/28/23.
//

import UIKit

class YWMultiColumnsGoodItemsViewModule: NSObject,YWCustomerLayoutSectionModuleProtocol {
    
    var columnHeights:[CGFloat] = []
    
    var minimumInteritemSpacing: CGFloat = 0.0
    
    var sectionDataList: [YWCollectionCellModelProtocol] = []
    
    var blockModel: YWThemeBlockModel?
    
    func childRowsCaclulateFramesWithBottomOffset(_ bottomOffset: CGFloat, _ section: Int) -> [UICollectionViewLayoutAttributes] {
        var attributeList:[UICollectionViewLayoutAttributes] = []
        
        return attributeList
    }
    
    func rowNumInSection() -> Int {
        self.sectionDataList.count
    }
    
    func sectionBottom() -> CGFloat {
        let index = YWCustomMathTool.longestColumnIndex(self.columnHeights)
        return self.columnHeights[index] + self.minimumInteritemSpacing
    }
    

}
