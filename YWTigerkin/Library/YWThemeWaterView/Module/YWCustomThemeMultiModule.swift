//
//  YWCustomThemeMultiModule.swift
//  YWTigerkin
//
//  Created by odd on 3/26/23.
//

import UIKit

class YWCustomThemeMultiModule: NSObject,YWCustomerLayoutSectionModuleProtocol {
    
    func sectionBottom() -> CGFloat {
        self.bottomOffset + self.minimumInteritemSpacing
    }
    
    
    
    private var bottomOffset: CGFloat = 0.0
    
    var minimumInteritemSpacing: CGFloat = 0.0
    
    var sectionDataList: [YWCollectionCellModelProtocol] = []
    
    var blockModel: YWThemeBlockModel?
    
    func childRowsCaclulateFramesWithBottomOffset(_ bottomOffset: CGFloat, _ section: Int) -> [UICollectionViewLayoutAttributes] {
        
        let rows = self.rowNumInSection()
        var attributeList:[UICollectionViewLayoutAttributes] = []
        var width = 0.0
        var height = 0.0
        let screenWidth = KSCREEN_WIDTH
        
        for i in 0..<rows {
            let cellModel = self.sectionDataList[i]
            let size = cellModel.customerSize()
            width = width + size.width
            height = size.height
        }
        if width <= 0 {
            width = 0.01
        }
        
        let widhtHeightScale = screenWidth / width
        let heightScale = height * widhtHeightScale
        
        // 翻转
        let rightToLeft = false
        var totalWidth = 0.0
        for i in 0..<rows {
            let indexPath = IndexPath(row: i, section: section)
            let cellModel = self.sectionDataList[i]
            let size = cellModel.customerSize()
            
            var reallyWidth = (size.width / width) * screenWidth
            if i == rows - 1 && rows > 1 {
                reallyWidth = screenWidth - totalWidth
            }
            totalWidth += reallyWidth
            let reallyHeight = heightScale
            
            var x = 0.0
            if i == 0 {
                x = 0.0
                if rightToLeft {
                    x = screenWidth - reallyWidth
                }
            } else {
                let lastAttributes = attributeList[i - 1]
                x = lastAttributes.frame.maxX
                if rightToLeft {
                    x = screenWidth - totalWidth
                }
            }
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: x, y: Double(bottomOffset), width: reallyWidth, height: Double(floorf(Float(reallyHeight))))
            self.bottomOffset = CGFloat(floorf(Float(attributes.frame.maxY)))
            attributeList.append(attributes)
        }
        
        return attributeList
    }
    
    func rowNumInSection() -> Int {
        self.sectionDataList.count
    }
    

}
