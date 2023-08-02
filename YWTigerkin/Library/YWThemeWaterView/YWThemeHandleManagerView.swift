//
//  YWThemeHandleManagerView.swift
//  YWTigerkin
//
//  Created by odd on 3/26/23.
//

import UIKit

@objc protocol YWThemeHandleManagerProtocol:NSObjectProtocol {
    /** Deeeplink跳转事件, 需要组装一个完整的deeplink字典来做跳转 */
    @objc func yw_themeManager(managerView: YWThemeHandleManagerView, collectionView: UICollectionView, eventCell:UICollectionViewCell, deepLinkItem:YWAdvsEventsModel)
    
    /** 只是用于统计*/
    @objc func yw_themeManager(managerView: YWThemeHandleManagerView, collectionView: UICollectionView, didSelectItemCell:UICollectionViewCell, indexPath:IndexPath)
}

class YWThemeHandleManagerView: UIView {

    var dataSourceList:[YWCustomerLayoutSectionModuleProtocol] = []
    weak var delegate:YWThemeHandleManagerProtocol?
    lazy var themeCollectionView: YWThemeCollectionView = {
        let view = YWThemeCollectionView(frame: CGRect.zero, collectionViewLayout: self.ywLayout)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        view.showsVerticalScrollIndicator = true
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = YWThemesColors.col_f6f6f6
        
        view.register(YWAsinglesAdvCCell.self, forCellWithReuseIdentifier: YWAsingleCCellModel.reuseIdentifier())
        return view
    }()
    ///是否有频道楼层
    var isChannel = false
    
    lazy var ywLayout:YWThemesMainLayout = {
        let view = YWThemesMainLayout()
        view.dataSource = self
        view.delegate = self
        view.showBottomsGoodsSeparate = true
        return view
    }()
    var menuView:UIView?
    
    var bgColor:UIColor?
    
    var footerBlock:(()->Void)?
    
    init(frame:CGRect, channelId:NSString, showRecommend:Bool) {
        super.init(frame: frame)
        self.ywInitView()
        self.ywAutoLayoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func clearDatas() {
        
    }
    
    func menuEndFootRefresh() {
        
    }
    
    /**
     视图显示刷新
     @param isEmptyDataRefresh ：YES：重置刷新，NO:加载刷新
     */
    func reloadView(_ isEmptyDataRefresh: Bool) {
        
    }
    
    /**
     禁止collect手势同时穿透传递
     @param forbid ：默认开启
     */
    func forbidCollectionRecognizeSimultaneously(_ forbid: Bool) {
        
    }
    
    /**
     不包括推荐商品高度
     @return
     */
    func noContainRecommendsGoodsHeight() -> CGFloat {
        return 0.0
    }
    
    /**
     获取最后一组的组尾minY
     @return
     */
    func lastSectionFooterMinY() -> CGFloat {
        return 0.0
    }
    
    /**
     双击tabbar滚动到推荐商品标题栏目位置
     */
    func scrollToRecommendPosition() {
        
    }
    
    /**
     移除组的背景图
     */
    func removeSectionBgColorView() {
        
    }
    
    /** 添加刷新事件*/
    func addListHeaderRefreshBlock(headerBlock:(()->Void)?, showBannerBlock:(()->Void)?,  footerBlock:(()->Void)?, startRefresh:Bool) {
        if let headBlock = headerBlock {
            let header = YWRefreshHeader {[weak self] in
                guard let `self` = self else {return}
                
                self.themeCollectionView.removeOldTipBgView()
                self.themeCollectionView.mj_footer?.endRefreshing()
                
                headBlock()
            }
            //隐藏时间
            header?.lastUpdatedTimeLabel.isHidden = true
            //隐藏状态
            header?.stateLabel.isHidden = true
            
            self.themeCollectionView.mj_header = header
            
            //是否立即刷新
            if startRefresh {
                self.themeCollectionView.mj_header?.beginRefreshing()
            }
        }
        
        if let footBlock = footerBlock {
            let footer = YWRefreshAuotNormalFooter {
                footBlock()
            }
            self.themeCollectionView.mj_footer = footer
            
            //这里需要先隐藏,否则已进入页面没有数据也会显示上拉View
            self.themeCollectionView.mj_footer?.isHidden = true
        }
    }
    
    /** 处理是否能加载更多*/
    func addFooterLoadingMore(showLoadingMore: Bool, footerBlock:(()->Void)?) {
        if showLoadingMore {
            if self.themeCollectionView.mj_footer == nil || self.themeCollectionView.mj_footer?.isHidden ?? false {
                self.themeCollectionView.mj_footer = YWRefreshAuotNormalFooter(refreshingBlock: {
                    footerBlock?()
                })
            }
        }
        self.themeCollectionView.mj_footer?.isHidden = !showLoadingMore
    }
    
    func endHeaderOrFooterRefresh(_ isEndHeader: Bool) {
        if let mjHeader = self.themeCollectionView.mj_header, mjHeader.isRefreshing {
            mjHeader.endRefreshing()
        }
        if isEndHeader {
            self.themeCollectionView.mj_header?.endRefreshing()
        } else {
            self.themeCollectionView.mj_footer?.endRefreshing()
        }
    }
    
    
    func customeFootRefreshAction() {
        self.footerBlock?()
    }
    
    //空数据提示
    func showRequestTipResult() {
        
        self.themeCollectionView.showRequestTip(nil)

    }
    
}

extension YWThemeHandleManagerView: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSourceList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let module = self.dataSourceList[section]
        return module.sectionDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:YWCollectCCellProtocol?
        if self.dataSourceList.count > indexPath.section {
            let module = self.dataSourceList[indexPath.section]
            
            if module.sectionDataList.count > indexPath.row {
                let model = module.sectionDataList[indexPath.row]
                
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier(), for: indexPath) as? YWCollectCCellProtocol
                
                cell?.model = model
                cell?.delegate = self
            }
        }
        if let tCell = cell as? UICollectionViewCell {
            return tCell
        }
        
        let tCell = collectionView.dequeueReusableCell(withReuseIdentifier: YWAsingleCCellModel.reuseIdentifier(), for: indexPath)
        return tCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tDelegate = self.delegate, tDelegate.responds(to: #selector(YWThemeHandleManagerProtocol.yw_themeManager(managerView:collectionView:didSelectItemCell:indexPath:))) {
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                
                tDelegate.yw_themeManager(managerView: self, collectionView: collectionView, didSelectItemCell: cell, indexPath: indexPath)
            }
        }
        
        let module = self.dataSourceList[indexPath.section]
        let model = module.sectionDataList[indexPath.row]
        
        if let modelSpeical = model.dataSource as? YWAdvEventSpecialModel {
            
            let advEventModel = YWAdvsEventsModel(modelSpeical)
            
            if modelSpeical.pageType == .home {
                
            } else {
//                YWAdvsEventsManager.advEventTarget(target: self.viewController(), advEventModel: advEventModel)
            }
            return
        }
        
        //
     }
    
}

extension YWThemeHandleManagerView: YWCollectionCellDelegate {
    
}
