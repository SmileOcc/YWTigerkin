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
}

class YWThemeHandleManagerView: UIView {

    var dataSourceList:[YWCustomerLayoutSectionModuleProtocol] = []
    weak var delegate:YWThemeHandleManagerProtocol?
    lazy var themeCollectionView: YWThemeCollectionView = {
        
        
        
        let view = YWThemeCollectionView()
        
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
    
    init(_ frame:CGRect, _ channelId:NSString, _ showRecommend:Bool) {
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
    func addListHeaderRefreshBlock(_ headerBlock:(()->Void)?, _ showBannerBlock:(()->Void)?, _ footerBlock:(()->Void)?, _ startRefresh:Bool) {
        
    }
    
    /** 处理是否能加载更多*/
    func addFooterLoadingMore(_ showLoadingMore: Bool, _ footerBlock:(()->Void)?) {
        
    }
    
    func endHeaderOrFooterRefresh(_ isEndHeader: Bool) {
        
    }
    
}
