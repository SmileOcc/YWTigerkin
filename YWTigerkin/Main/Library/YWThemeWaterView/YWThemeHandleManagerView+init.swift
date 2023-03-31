//
//  YWThemeHandleManagerView+init.swift
//  YWTigerkin
//
//  Created by odd on 3/30/23.
//

import Foundation

extension YWThemeHandleManagerView {
    
    func ywInitView() {
        self.addSubview(self.themeCollectionView)
    }
    func ywAutoLayoutView() {
        self.themeCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func themeMenuDataIndex() -> Int {
        var section = -1
        
        if let channelIndex  = self.dataSourceList.firstIndex(where: { model in
            if let template = model as? YWAsinglViewModule {
                if let _ = template.sectionDataList.first as? YWHomeChannelCCellModel {
                    return true
                }
            }
            return false
        }) {
            section = channelIndex
        }

        return section
    }
    
}

extension YWThemeHandleManagerView: YWCustomerLayoutDataSource, YWCustomerLayoutDelegate {
    func customerLayoutDataSource(_ collectionView: UICollectionView, _ section: Int) -> YWCustomerLayoutSectionModuleProtocol {
        let module = self.dataSourceList[section]
        return module
    }
    
    func customerLayoutSectionHeightHeight(_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ indexPath: NSIndexPath) -> CGFloat {
        
        return 0.01
    }
    
    func customerLayoutSectionFooterHeight(_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ indexPath: NSIndexPath) -> CGFloat {
        return 0.01
    }
    
    func customerLayoutThemeMenusSection(_ collectionView: UICollectionView) -> Int {
        
    }
    
    func customerLayoutDidLayoutDone() {
        
    }
    
    
}
