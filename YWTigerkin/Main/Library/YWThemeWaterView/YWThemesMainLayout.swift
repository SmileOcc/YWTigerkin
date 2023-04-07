//
//  YWThemesMainLayout.swift
//  YWTigerkin
//
//  Created by odd on 3/26/23.
//

import UIKit

let kCustomerDefaultBottomPadding = 20.0
let CustomerLayoutHeader = "CustomerLayoutHeader"
let CustomerLayoutFooter = "CustomerLayoutFooter"

@objc protocol YWCustomerLayoutDataSource:NSObjectProtocol {
    @objc func customerLayoutDataSource(_ collectionView: UICollectionView, _ section: Int) -> YWCustomerLayoutSectionModuleProtocol
    
    @objc func customerLayoutSectionHeightHeight(_ collectionView: UICollectionView, _ layout:UICollectionViewLayout, _ indexPath: NSIndexPath) -> CGFloat
    
    @objc func customerLayoutSectionFooterHeight(_ collectionView: UICollectionView, _ layout:UICollectionViewLayout, _ indexPath: NSIndexPath) -> CGFloat
    
    // 返回section menu位置，没有就返回-1
    @objc func customerLayoutThemeMenusSection(_ collectionView: UICollectionView) -> Int
}

@objc protocol YWCustomerLayoutDelegate:NSObjectProtocol {
    @objc func customerLayoutDidLayoutDone()
}

class YWThemesMainLayout: UICollectionViewLayout {
    
    var dataSource: YWCustomerLayoutDataSource?
    var delegate: YWCustomerLayoutDelegate?
    
    ///存储每个section最终bottom
    var columnHeightsArray: [CGFloat] = []
    var showBottomsGoodsSeparate = false
    
    ///按分区存放的attributes
    private var attributesListArray:[[UICollectionViewLayoutAttributes]] = []
    ///所有的attributes
    private var allAttributesItemListArray:[UICollectionViewLayoutAttributes] = []
    
    ///需要显示在屏幕上的
    private var visibleItemsArr:[CGRect] = []
    private var headerSectionHeightDic:[Int:UICollectionViewLayoutAttributes] = [:]
    private var footerSectionHeightDic:[Int:UICollectionViewLayoutAttributes] = [:]
    private var reloadSection: Int = -1
    
    override init() {
        super.init()
        self.reloadSection = -1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
        插入section数
        用于重新计算布局，使用该方法时需要调用 collectoin 的 reloadata方法
        当大于当前section时，默认插入到队列尾部
     */
    func inserSection(_ section: Int) {
        self.reloadSection = section
    }
    
    /*
         刷新section
         用于重新计算布局，使用该方法时需要调用 collectoin 的 reloadata方法
         当大于当前section时，默认插入到队列尾部
     */
    func reloadSection(_ section: Int) {
        self.reloadSection = section
    }
    
    func customerLastSectionFirstViewTop() -> CGFloat {
        
        return 0.0
    }
    
    /*
        通过传入的section，获取指定分区的第一个布局结构
        可以使用 delegate customerLayoutDidLayoutDone 获取布局完成的状态
     */
    func customerSectionFirstAttribute(_ section: Int) -> CGRect {
        
        return CGRect.zero
    }
}


extension YWThemesMainLayout {
    
    override func prepare() {
        super.prepare()
        
        if self.collectionView == nil {
            return
        }
        var startSection = 0
        
        if self.reloadSection >= 0 {
            var allcount = 0
            startSection = self.reloadSection
            self.reloadSection = -1
            
            let tempArr = self.attributesListArray
            if tempArr.count >= startSection {
                for (index,itemList) in tempArr.enumerated() {
                    if index >= startSection {
//                        let itemList = tempArr[index]
                        allcount += itemList.count
                    }
                }
            }
            
            let allListCount = self.allAttributesItemListArray.count
            var removeAllRange = NSMakeRange(allListCount - allcount, allcount)
            let allDeletLength = removeAllRange.location + removeAllRange.length
            
            if allListCount < allDeletLength {
                if removeAllRange.location > allListCount {
                    removeAllRange.location = allListCount
                }
                removeAllRange = NSMakeRange(removeAllRange.location, allListCount - removeAllRange.location)
            }
            
            self.allAttributesItemListArray.removeSubrange(removeAllRange.location...removeAllRange.length)
            
            var listCount = self.attributesListArray.count
            var len = listCount - startSection
            var removeRange = NSMakeRange(startSection, len > 0 ? len : 0)
            var deleteLength = removeRange.location + removeRange.length
            
            if listCount < deleteLength {
                if removeRange.location > listCount {
                    startSection = listCount
                }
                removeRange = NSMakeRange(startSection, listCount - startSection)
            }
            self.attributesListArray.removeSubrange(removeRange.location...removeRange.length)
            
            let removeColunmEnd = self.columnHeightsArray.count - startSection
            self.columnHeightsArray.removeSubrange(startSection...removeColunmEnd)
            self.visibleItemsArr.removeAll()
            
        } else {
            self.attributesListArray.removeAll()
            self.allAttributesItemListArray.removeAll()
            self.columnHeightsArray.removeAll()
            self.visibleItemsArr.removeAll()
            self.headerSectionHeightDic.removeAll()
            self.footerSectionHeightDic.removeAll()
        }
        
        let sections = self.collectionView?.numberOfSections ?? 0
        var lastSectionModule:YWCustomerLayoutSectionModuleProtocol?
        if let tDataSource = self.dataSource {
            if tDataSource.responds(to: #selector(YWCustomerLayoutDataSource.customerLayoutDataSource(_:_:))) {
                
                for i in startSection..<sections {
                    let sectionModule = tDataSource.customerLayoutDataSource(self.collectionView!, i)
                    var sectionHeight = 0.0
                    var sectionAttributes:[UICollectionViewLayoutAttributes] = []
                    
                    if tDataSource.responds(to: #selector(YWCustomerLayoutDataSource.customerLayoutSectionHeightHeight(_:_:_:))) {
                        sectionHeight = tDataSource.customerLayoutSectionHeightHeight(self.collectionView!, self, IndexPath(row: 0, section: i) as NSIndexPath)
                        if sectionHeight > 0 {
                            //section header
                            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CustomerLayoutHeader, with: IndexPath(row: 0, section: i))
                            let lastSectionHeight = self.columnHeightsArray.last ?? 0.0
                            headerAttributes.frame = CGRect(x: 0.0, y: lastSectionHeight, width: self.collectionView!.frame.size.width, height: sectionHeight)
                            self.allAttributesItemListArray.append(headerAttributes)
                            self.headerSectionHeightDic[i] = headerAttributes
                            sectionHeight = headerAttributes.frame.maxY
                        }
                    }
                    
                    //获取上一个section的bottom
                    var lastSectionHeight = max(sectionHeight, self.columnHeightsArray.last ?? 0.0)
                    if self.showBottomsGoodsSeparate && sectionModule is YWWaterFallViewModule {
                        if (lastSectionModule == nil) || !(lastSectionModule is YWWaterFallViewModule) {
                            lastSectionHeight += kPadding
                        }
                    }
                    
                    if self.showBottomsGoodsSeparate && sectionModule is YWMultiColumnsGoodItemsViewModule {
                        if lastSectionModule == nil || !(lastSectionModule is YWMultiColumnsGoodItemsViewModule) {
                            lastSectionHeight += kPadding
                        }
                    }
                    
                    let sectionAttributelist = sectionModule.childRowsCaclulateFramesWithBottomOffset(lastSectionHeight, i)
                    sectionAttributes.append(contentsOf: sectionAttributelist)
                    
                    self.columnHeightsArray.append(sectionModule.sectionBottom())
                    
                    var sectionFooter = 0.0
                    if tDataSource.responds(to: #selector(YWCustomerLayoutDataSource.customerLayoutSectionFooterHeight(_:_:_:))) {
                        
                        sectionFooter = tDataSource.customerLayoutSectionFooterHeight(self.collectionView!, self, NSIndexPath(row: 0, section: i))
                        if sectionFooter > 0 {
                            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CustomerLayoutFooter, with: IndexPath(row: 0, section: i))
                            let lastSectionHeight:CGFloat = self.columnHeightsArray.last ?? 0.0
                            headerAttributes.frame = CGRect(x: 0.0, y: lastSectionHeight, width: self.collectionView!.frame.size.width, height: sectionFooter)
                            self.allAttributesItemListArray.append(headerAttributes)
                            self.footerSectionHeightDic[i] = headerAttributes
                            //self.columnHeightsArray[i] = headerAttributes.frame.maxY
                            self.columnHeightsArray.append(headerAttributes.frame.maxY)
                        }
                    }
                    
                    lastSectionHeight = max(sectionFooter, self.columnHeightsArray.last ?? 0.0)
                    self.attributesListArray.append(sectionAttributes)
                    self.allAttributesItemListArray.append(contentsOf: sectionAttributes)
                    
                    lastSectionModule = sectionModule
                }
            }
            
            
        }
        
        var idx = 0
        let itemCounts = self.allAttributesItemListArray.count
        while idx < itemCounts {
            let rect1 = self.allAttributesItemListArray[idx].frame
            idx = min(idx + Int(kCustomerDefaultBottomPadding), itemCounts) - 1
            let rect2 = self.allAttributesItemListArray[idx].frame
            self.visibleItemsArr.append(rect1.union(rect2))
            idx += 1
        }
        
        if self.attributesListArray.count > 0 {
            if let tDelegate = self.delegate, tDelegate.responds(to: #selector(YWCustomerLayoutDelegate.customerLayoutDidLayoutDone)) {
                tDelegate.customerLayoutDidLayoutDone()
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var begin = 0, end = self.visibleItemsArr.count
        var attrs:[UICollectionViewLayoutAttributes] = []
        
        for i in 0..<self.visibleItemsArr.count {
            if rect.intersects(self.visibleItemsArr[i] ) {
                begin = i * Int(kCustomerDefaultBottomPadding)
                break
            }
        }
        let range = 0..<self.visibleItemsArr.count
        for i in range.reversed() {//倒序
            
            if rect.intersects(self.visibleItemsArr[i]) {
                end = min((i + 1) * Int(kCustomerDefaultBottomPadding), self.allAttributesItemListArray.count)
                break
            }
        }
        
        for i in begin..<end {
            let attr = self.allAttributesItemListArray[i]
            if rect.intersects(attr.frame) {
                attrs.append(attr)
            }
        }
        
        return attrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= self.attributesListArray.count {
            return nil
        }
        if indexPath.item >= self.attributesListArray[indexPath.section].count {
            return nil
        }
        
        let attributes = self.attributesListArray[indexPath.section][indexPath.item]
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == CustomerLayoutHeader {
            return self.headerSectionHeightDic[indexPath.section]
        }
        if elementKind == CustomerLayoutFooter {
            return self.footerSectionHeightDic[indexPath.section]
        }

        return nil
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            if let collectView = self.collectionView, collectView.numberOfSections > 0 {
                var contentSize = collectView.bounds.size
                contentSize.height = self.columnHeightsArray.last ?? 0.0
                return contentSize
            }
            return CGSize.zero
        }
    }
}
