//
//  YWWaterFallViewMould.swift
//  YWTigerkin
//
//  Created by odd on 3/28/23.
//

import UIKit

class YWWaterFallViewModule: NSObject,YWCustomerLayoutSectionModuleProtocol {
    var minimumInteritemSpacing: CGFloat = 0.0
    
    var sectionDataList: [YWCollectionCellModelProtocol] = []
    
    var blockModel: YWThemeBlockModel?
    
    func childRowsCaclulateFramesWithBottomOffset(_ bottomOffset: CGFloat, _ section: Int) -> [UICollectionViewLayoutAttributes] {
        var attributeList:[UICollectionViewLayoutAttributes] = []
        let rows = self.rowNumInSection()
        
        for _ in 0..<kColumnIndex2 {
            self.columnHeights.append(bottomOffset)
        }
        let rightToLeft = false
        let screenWidth = KSCREEN_WIDTH
        for i in 0..<rows {
            
            let indexPath = IndexPath(row: i, section: section)
            let model:YWCollectionCellModelProtocol = self.sectionDataList[i]
            let width = model.customerSize().width
            let height = model.customerSize().height
            
            let columnHeightIndex = YWCustomMathTool.shortestColumnIndex(self.columnHeights)
            let widthSpace = width + kPadding
            var xOffset = kPadding + widthSpace * CGFloat(columnHeightIndex)
            
            if rightToLeft {
                xOffset = screenWidth - xOffset - width
            }
            
            var yOffset = self.columnHeights[columnHeightIndex]
            var attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            if self.isTopSpace && i < kColumnIndex2 {
                yOffset += kPadding
            }
            attributes.frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
            
            self.columnHeights[columnHeightIndex] = attributes.frame.maxY + kBottomPadding
            attributeList.append(attributes)
        }
        
        return attributeList
    }
    
    func rowNumInSection() -> Int {
        self.sectionDataList.count
    }
    
    func sectionBottom() -> CGFloat {
        let index = YWCustomMathTool.longestColumnIndex(self.columnHeights)
        return self.columnHeights[index] + self.minimumInteritemSpacing
    }
    

    var isTopSpace: Bool = false
    var columnHeights:[CGFloat] = []
}
