//
//  UIScrollView+ODBlankPageTipView.swift
//  URLDEMO
//
//  Created by odd on 7/16/22.
//

import UIKit
import RxCocoa


enum OBBlankPageStatus {
    case normal
    case emptyData
    case fail
    case noNetwork
}

let kNetworkConnectDefaultFailTips: String = "There is no internet connection. Please check your network."
/** 刷新提示文案 */
let kAgainRequestDefaultTipString: String  = "Loading failed, please try again later."

/** 请求失败默认提示文案 */
let kReqFailDefaultTipText: String = "Loading failed, please try again later."
/** 请求空数据默认提示文案 */
let kEmptyDataDefaultTipText: String =   "Oops,no data displayed"

let kEmptyDataDefaultRefreshButton: String  = "Retry"

extension UIScrollView {
    
    private struct OBEmptyKey {
        static var emptyDataTitle = "OBEmptyDataTitle"
        static var emptyDataSubTitle = "OBEmptyDataSubTitle"
        static var emptyDataImage = "OBEmptyDataImage"
        static var emptyDataButtonTitle = "OBEmptyDataButtonTitle"
        static var requestFailTitle = "OBRequestFailTitle"
        static var requestFailImage = "OBRequestFailImage"
        static var requestFailButtonTitle = "OBRequestFailButtonTitle"
        static var networkErrorTitle = "OBNetworkErrorTitle"
        static var networkErrorImage = "OBNetworkErrorImage"
        static var networkErrorButtonTitle = "OBNetworkErrorButtonTitle"

        static var blankActionBlock = "OBBlankActionBlock"
        static var blankPageViewCenter = "OBBlankPageViewCenter"
        static var blankPageImageTopDistance = "OBBlankPageImageTopDistance"
        static var blankPageTipViewTopDistance = "OBBlankPageTipViewTopDistance"
        static var blankPageTipViewOffsetY = "OBBlankPageTipViewOffsetY"
        static var ignoreHeaderOrFooter = "OBIgnoreHeaderOrFooter"
        static var showDropBanner = "OBShowDropBanner"

    }
    
    // ==================== 请求空数据标题 ====================

    var emptyDataTitle: String {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.emptyDataTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.emptyDataTitle) as? String ?? kEmptyDataDefaultTipText)
        }
    }
    
    // ==================== 请求空数据副标题 ====================

    var emptyDataSubTitle: String {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.emptyDataSubTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.emptyDataSubTitle) as? String ?? "")
        }
    }
    
    // ==================== 请求空数据图片 ====================
    var emptyDataImage: UIImage? {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.emptyDataImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.emptyDataImage) as? UIImage ?? UIImage(named: "recently_data_bank"))
        }
    }
    
    // ==================== 空数按钮点标题 ====================
    var emptyDataButtonTitle: String {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.emptyDataButtonTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.emptyDataButtonTitle) as? String ?? "")
        }
    }
    
    // ==================== 请求失败提示 ====================

    var requestFailTitle: String {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.requestFailTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.requestFailTitle) as? String ?? kNetworkConnectDefaultFailTips)
        }
    }
    
    // ==================== 请求失败图片 ====================
    var requestFailImage: UIImage? {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.requestFailImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.requestFailImage) as? UIImage ?? UIImage(named: "recently_data_bank"))
        }
    }
    
    // ==================== 请求失败按钮点标题 ====================
    var requestFailButtonTitle: String {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.requestFailButtonTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.requestFailButtonTitle) as? String ?? "")
        }
    }
    
    // ==================== 网络错误提示 ====================
    var networkErrorTitle: String {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.networkErrorTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.networkErrorTitle) as? String ?? kNetworkConnectDefaultFailTips)
        }
    }
    
    // ==================== 网络错误图片 ====================
    var networkErrorImage: UIImage? {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.networkErrorImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.networkErrorImage) as? UIImage ?? UIImage(named: "recently_data_bank"))
        }
    }
    
    // ==================== 网络失败按钮点标题 ====================
    var networkErrorButtonTitle: String? {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.networkErrorButtonTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.networkErrorButtonTitle) as? String)
        }
    }
    
    // ==================== 网络连接按钮点击事件回调 ====================
    var blankPageActionBlock: ((OBBlankPageStatus) -> Void)? {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.blankActionBlock, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &OBEmptyKey.blankActionBlock) as? (OBBlankPageStatus) -> Void)
        }
    }
    
    // ==================== 提示View的中心位置 ====================
    var blankPageViewCenter: CGPoint {
        set {
            let centerObj = "\(newValue)"
            objc_setAssociatedObject(self, &OBEmptyKey.blankPageViewCenter, centerObj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if let tipView = self.viewWithTag(kBlankTipViewTag) as? ODBlankPageTipView {
                tipView.center = blankPageViewCenter
            }

        }
        get {
            let centerObj = objc_getAssociatedObject(self, &OBEmptyKey.blankPageViewCenter) as? String ?? "(0,0)"
            return NSCoder.cgPoint(for: centerObj)
        }
    }
    
    // ==================== 外部可控制内容提示tipView的距离顶部距离 ====================
    var blankPageImageTopDistance: Float {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.blankPageImageTopDistance, "\(newValue)", .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        }
        get {
            let centerObj = objc_getAssociatedObject(self, &OBEmptyKey.blankPageImageTopDistance) as? String ?? "0"
            return Float(centerObj) ?? 0
        }
    }
    
    var blankPageTipViewTopDistance: Float {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.blankPageTipViewTopDistance, "\(newValue)", .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        }
        get {
            let centerObj = objc_getAssociatedObject(self, &OBEmptyKey.blankPageTipViewTopDistance) as? String ?? "0"
            return Float(centerObj) ?? 0
        }
    }
    
    // ==================== 外部可控制内容提示tipView的中心上移距离 ====================

    var blankPageTipViewOffsetY: Float {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.blankPageTipViewOffsetY, "\(newValue)", .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        }
        get {
            let centerObj = objc_getAssociatedObject(self, &OBEmptyKey.blankPageTipViewOffsetY) as? String ?? "0"
            return Float(centerObj) ?? 0
        }
    }
    
    // ==================== 是否忽略头尾 ====================

    var isIgnoreHeaderOrFooter: Bool {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.ignoreHeaderOrFooter, "\(newValue)", .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        }
        get {
            let centerObj = objc_getAssociatedObject(self, &OBEmptyKey.ignoreHeaderOrFooter) as? String ?? "0"
            return Bool(centerObj) ?? false
        }
    }
    
    // ==================== 显示全屏下拉banner ====================

    var showDropBanner: Bool {
        set {
            objc_setAssociatedObject(self, &OBEmptyKey.showDropBanner, "\(newValue)", .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        }
        get {
            let centerObj = objc_getAssociatedObject(self, &OBEmptyKey.showDropBanner) as? String ?? "0"
            return Bool(centerObj) ?? false
        }
    }
    
    // ==================== 给表格添加上下拉刷新事件 ====================
    func addHeaderRefreshBlock(headerBlock:(()->Void)?, footerBlock:(()->Void)?, startRefreshing:Bool) {
        if let headBlock = headerBlock {
            let header = YWRefreshHeader {[weak self] in
                guard let `self` = self else {return}
                //1.先移除页面上已有的提示视图
                self.removeOldTipBgView()
                //2.每次下拉刷新时先结束上啦
                self.mj_footer.endRefreshing()
                headBlock()
            }
            self.mj_header = header
            //是否需要立即刷新
            if startRefreshing {
                self.mj_header.beginRefreshing()
            }
        }
        
        if let foterBlock = footerBlock {
            let footer = YWRefreshAuotNormalFooter {
                foterBlock()
            }
            self.mj_footer = footer
            //这里需要先隐藏,否则已进入页面没有数据也会显示上拉View
            self.mj_footer.isHidden = true
        }
    }
    
    // 初始化表格的上下拉刷新控件  广告刷新
    func addHeaderRefresh(headerBlock:(()->Void)?, showBannerBlock:(()->Void)?, footerBlock:(()->Void)?, startRefrshing:Bool) {
        addHeaderRefresh(headerBlock: headerBlock, showBannerBlock: showBannerBlock, dropPullingBlock: nil, footerBlock: footerBlock, startRefrshing: startRefrshing)
    }
    
    func addHeaderRefresh(headerBlock:(()->Void)?, showBannerBlock:(()->Void)?,dropPullingBlock:(()->Void)?, footerBlock:(()->Void)?, startRefrshing:Bool) {
        
        if let headBlock = headerBlock {
            let header = YWRefreshHeader {[weak self] in
                guard let `self` = self else {return}
                self.removeOldTipBgView()
                self.mj_footer.endRefreshing()
                headBlock()
            }
            
            header?.dropBannerBlock = {
                dropPullingBlock?()
            }
            
            header?.dropPullingBlock = {
                dropPullingBlock?()
            }
            
            
            self.mj_header = header
            if startRefrshing {
                self.mj_header.beginRefreshing()
            }
        }
        
        if let footBlock = footerBlock {
            let footer = YWRefreshFooter {
                footBlock()
            }
            self.mj_footer = footer
            //这里需要先隐藏,否则已进入页面没有数据也会显示上拉View
            self.mj_footer.isHidden = true
        }
    }
    
    //开始加载头部数据
    //加载时是否需要动画
    func headerRefreshingByAnimation(_ animation: Bool) {
        if let mjHeader = self.mj_header {
            if animation {
                mjHeader.beginRefreshing()
            } else if mjHeader.responds(to: #selector(MJRefreshComponent.executeRefreshingCallback)){
                mjHeader.executeRefreshingCallback()
            }
        }
        
    }

    //MARK: - 先移除页面上已有的提示视图
    func removeOldTipBgView() {
        self.subviews.forEach { view in
            if view is ODBlankPageTipView && view.tag == kBlankTipViewTag{
                view.removeFromSuperview()
            }
        }
    }
    
    //MARK: - 判断ScrollView页面上是否有数据
    func contentViewIsEmptyData() -> Bool {
        var isEmptyCell = true
        var sections = 1
        
        if let tableView = self as? UITableView {
            if !self.isIgnoreHeaderOrFooter && (tableView.tableHeaderView?.bounds.size.height ?? 0 > 10 || tableView.tableFooterView?.bounds.size.height ?? 0 > 10) {
                return false
            }
            
            
            if let dataSource = tableView.dataSource {
                if dataSource.responds(to: #selector(UITableViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: tableView)
                }
                for i in 0..<sections {
                    let rows = dataSource.tableView(tableView, numberOfRowsInSection: i)
                    if rows > 0 {
                        isEmptyCell = false
                        break
                    }
                }
                
                // 如果每个Cell没有数据源, 则还需要判断Header和Footer高度是否为0
                if isEmptyCell {
                    if let tDelegate = tableView.delegate {
                        var isEmptyHeader = true
                        
                        if tDelegate.responds(to: #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:))) {
                            
                            for h in 0..<sections {
                                let headerHeight = tDelegate.tableView!(tableView, heightForHeaderInSection: h)
                                if headerHeight > 1.0 {
                                    isEmptyHeader = false
                                    isEmptyCell = false
                                }
                            }
                        }
                        
                        // 如果Header没有高度还要判断Footer是否有高度
                        if isEmptyHeader {
                            if tDelegate.responds(to: #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:))) {
                                
                                for k in 0..<sections {
                                    let footerHeight = tDelegate.tableView!(tableView, heightForFooterInSection: k)
                                    
                                    if footerHeight > 1.0 {
                                        isEmptyCell = false
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else if let collectionView = self as? UICollectionView {
            if let dataSource = collectionView.dataSource {
                if dataSource.responds(to: #selector(UICollectionViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: collectionView)
                    
                    for i in 0..<sections {
                        let rows = dataSource.collectionView(collectionView, numberOfItemsInSection: i)
                        if rows > 0 {
                            isEmptyCell = false
                        }
                    }
                    
                    // 如果每个ItemCell没有数据源, 则还需要判断Header和Footer高度是否为0
                    if isEmptyCell {
                        var isEmptyHeader = false
                        if let delegateFlowLayout = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
                            
                            if delegateFlowLayout.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:referenceSizeForHeaderInSection:))) {
                                
                                for h in 0..<sections {
                                    let size = delegateFlowLayout.collectionView!(collectionView, layout: collectionView.collectionViewLayout, referenceSizeForHeaderInSection: h)
                                    if size.height > 1.0 {
                                        isEmptyHeader = false
                                        isEmptyCell = false
                                        break
                                    }
                                }
                            }
                            
                            // 如果Header没有高度还要判断Footer是否有高度
                            if isEmptyHeader {
                                if delegateFlowLayout.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:referenceSizeForFooterInSection:))) {
                                    
                                    for k in 0..<sections {
                                        
                                        let size = delegateFlowLayout.collectionView!(collectionView, layout: collectionView.collectionViewLayout, referenceSizeForFooterInSection: k)
                                        if size.height > 1.0 {
                                            isEmptyCell = false
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            if self.isHidden || self.alpha == 0 {
                isEmptyCell = false
            } else {
                isEmptyCell = true
            }
        }
        return isEmptyCell
    }
    
    
    func showRequestTip(_ pageInfoDic:[String:Any]?) {
        var requestSuccess = false
        var dalyTime = 0.5
        if let _ = pageInfoDic {
            requestSuccess = true
            dalyTime = 0.0
        }
        
        if let _ = self.mj_header {
            DispatchQueue.main.asyncAfter(deadline: .now() + dalyTime, execute: {[weak self] in
                guard let `self` = self else {return}
                self.mj_header?.endRefreshing()
            })
        }
        if let _ = self.mj_footer {
            DispatchQueue.main.asyncAfter(deadline: .now() + dalyTime, execute: {[weak self] in
                guard let `self` = self else {return}
                if requestSuccess {
                    self.pageFooterEndRefreshStatus(pageInfoDic)
                } else {
                    self.mj_footer.endRefreshing()
                }
            })
        }
        
        if self.contentViewIsEmptyData() {
            //根据状态,显示背景提示Viwe
            if YWNetworkReachabilityManager.shared().isReachable() == false {
                //显示没有网络提示
                self.showTipWithStatus(.noNetwork)
            } else {
                let status:OBBlankPageStatus = requestSuccess ? .emptyData : .fail
                self.showTipWithStatus(status)
            }
        } else {
            self.removeOldTipBgView()
            if requestSuccess && self.mj_footer != nil {
                //控制刷新控件显示的分页逻辑
                self.pageRefreshStatus(pageInfoDic)
            }
            
            //分页时页面上有数据，但下拉失败时需要提示
            if !requestSuccess && self.mj_header != nil {
                if var vcView = self.superview, vcView.height < 600.0{
                    
                }
                //ShowToastToViewWithText(vcView, "EmptyCustomViewManager_titleLabel");
            }
        }
    }
    
    //控制刷新控件显示的分页逻辑
    func pageFooterEndRefreshStatus(_ dataInfo:[String:Any]?) {
        if let dataDic = dataInfo {
            let totalPage = dataDic[kTotalPageKey] as? String ?? ""
            let currentPage = dataDic[kCurrentPageKye] as? String ?? ""
            
            if totalPage.toInt() > currentPage.toInt() {
                self.mj_footer.isHidden = false
            } else {
                self.mj_footer.endRefreshingWithNoMoreData()
                self.mj_footer.isHidden = false
            }
        } else {
            self.mj_footer.endRefreshingWithNoMoreData()
            self.mj_footer.isHidden = true
        }
    }
    
    //MARK: - 如果请求失败,无网络则展示空白提示view
    func showTipWithStatus(_ state: OBBlankPageStatus) {
        self.removeOldTipBgView()
        
        let removeTipRefreshHeaderBlock = {[weak self] in
            guard let `self` = self else {return}
            if let mjHeader = self.mj_header, mjHeader.state == .idle {
                self.removeOldTipBgView()
                mjHeader.beginRefreshing()
            }
            
        }
        let blankViewBtnActionBlock = {[weak self] in
            guard let `self` = self else {return}
            if let bankActionBlock = self.blankPageActionBlock {
                if state != .emptyData {
                    self.removeOldTipBgView()
                }
                bankActionBlock(state)
            }
        }
        
        var tipString: String?
        var subTipString: String?
        var tipImage: UIImage?
        var actionBtnTitle: String?
        var actionBtnBlock:(()->Void)?
        
        if state == .noNetwork {
            tipString = self.networkErrorTitle
            tipImage = self.networkErrorImage
            actionBtnTitle = self.networkErrorButtonTitle ?? kAgainRequestDefaultTipString
            
            if let _ = self.blankPageActionBlock {
                actionBtnBlock = blankViewBtnActionBlock
            } else if let _ = self.mj_header {
                actionBtnBlock = removeTipRefreshHeaderBlock
            }
        } else if state == .emptyData {
            tipString = self.emptyDataTitle
            tipImage = self.emptyDataImage
            subTipString = self.emptyDataSubTitle
            actionBtnTitle = self.emptyDataButtonTitle
            if let _ = self.blankPageActionBlock {
                actionBtnBlock = blankViewBtnActionBlock
            } else {
                actionBtnTitle = nil
            }
        } else if state == .fail {
            tipString = self.requestFailTitle
            tipImage = self.requestFailImage
            actionBtnTitle = self.networkErrorButtonTitle ?? kAgainRequestDefaultTipString
            
            if let _ = self.blankPageActionBlock {
                actionBtnBlock = blankViewBtnActionBlock
            } else if let _ = self.mj_header {
                actionBtnBlock = removeTipRefreshHeaderBlock
            }
        } else {
            return
        }
        
        //防止添加空视图
        if tipString == nil && tipImage == nil && subTipString == nil && actionBtnTitle == nil {
            return
        }
        
        let contentInsetLeft = self.contentInset.left
        let contentInsetRight = self.contentInset.right
        let rect = CGRect(x: 0, y: 0, width: self.bounds.size.width - contentInsetLeft - contentInsetRight, height: self.bounds.size.height)
        //只能上移
        let tipTopY = self.blankPageTipViewOffsetY > 0 ? self.blankPageTipViewOffsetY : 0.0
        let topDistance = self.blankPageImageTopDistance > 0 ? self.blankPageImageTopDistance : 0.0
        
        let tipBgView = ODBlankPageTipView.tipViewByFrame(frame: rect,
                                                          topDistance: CGFloat(topDistance),
                                                          moveOffsetY: CGFloat(tipTopY),
                                                          topImage: tipImage,
                                                          title: tipString,
                                                          subTitle: subTipString,
                                                          buttonTitle: actionBtnTitle,
                                                          actionBlock: actionBtnBlock)
        
        if self.backgroundColor != nil {
            tipBgView.backgroundColor = self.backgroundColor
        }
        self.addSubview(tipBgView)
        //外部可控制提示View的中心位置
        if self.blankPageViewCenter.x != 0 && self.blankPageViewCenter.y != 0 {
            tipBgView.center = self.blankPageViewCenter
        }
        
        if self.blankPageImageTopDistance > 0 {
            var frame = tipBgView.frame
            frame.origin.y = CGFloat(self.blankPageTipViewTopDistance)
            tipBgView.frame = frame
        }
    }

    //MARK: - 控制刷新控件显示的分页逻辑
    func pageRefreshStatus(_ dataInfo: [String:Any]?) {
        if let dataDic = dataInfo {
            let totalPage = dataDic[kTotalPageKey] as? String ?? ""
            let currentPage = dataDic[kCurrentPageKye] as? String ?? ""
            
            if !totalPage.isEmpty && !currentPage.isEmpty {
                if totalPage.toInt() > currentPage.toInt() {
                    self.mj_footer.isHidden = false
                } else {
                    self.mj_footer.endRefreshingWithNoMoreData()
                }
                
            } else if let dataArray = dataDic[kListKey] as? [Any] {
                if dataArray.count > 0 {
                    self.mj_footer.isHidden = false
                } else {
                    self.mj_footer.endRefreshingWithNoMoreData()
                }
            }
        } else {
            self.mj_footer.endRefreshingWithNoMoreData()
        }
    }
}
