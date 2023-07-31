//
//  YWAsinglViewModule.swift
//  YWTigerkin
//
//  Created by odd on 3/30/23.
//

import UIKit

class YWAsinglViewModule: NSObject,YWCustomerLayoutSectionModuleProtocol {
    
    var bottomOffset:CGFloat = 0.0
    
    var minimumInteritemSpacing: CGFloat = 0.0
    
    var sectionDataList: [YWCollectionCellModelProtocol] = []
    
    var blockModel: YWThemeBlockModel?
    
    func childRowsCaclulateFramesWithBottomOffset(_ bottomOffset: CGFloat, _ section: Int) -> [UICollectionViewLayoutAttributes] {
        var attributeList:[UICollectionViewLayoutAttributes] = []
        
        self.bottomOffset = bottomOffset
        if let cellModel = self.sectionDataList.first {
            var customerSize = cellModel.customerSize()
            if CGSize.zero.equalTo(customerSize) {
                customerSize = CGSize(width: KSCREEN_WIDTH, height: floor(KSCREEN_WIDTH * 200.0 / 375.0))
            }
            
            let indexPath = NSIndexPath(row: 0, section: section)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
            attributes.frame = CGRect(x: 0, y: bottomOffset, width: customerSize.width, height: customerSize.height)
            self.bottomOffset = attributes.frame.maxY
            attributeList.append(attributes)
            
        }
        return attributeList
    }
    
    func rowNumInSection() -> Int {
        self.sectionDataList.count
    }
    
    func sectionBottom() -> CGFloat {
        self.bottomOffset + self.minimumInteritemSpacing
    }
    

    
}
