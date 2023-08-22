//
//  YWThemesMainView.swift
//  YWTigerkin
//
//  Created by odd on 3/26/23.
//

import UIKit

let kRefreFavoriteNotif = "kRefreFavoriteNotif"

class YWThemesMainView: UIView {

    var customId:String = ""
    var title:String = ""
    var page:Int = 1
    var isChannel = false
    // 1 单列 2 双
    var recommendType:Int = 1
    
    var recommendDatas:[Any] = []
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    init(frame: CGRect, firstChannel:String, channelId:String, title:String) {
        super.init(frame: frame)
        self.page = 1
        self.title = title
        self.customId = channelId
        
        self.ywInitView()
        self.ywAutoLayoutView()
        self.addNotification()
        requestCustomData(false)
        //odd测试数据
        //handResult()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ywInitView() {
        self.addSubview(self.themeManagerView)
    }
    
    func ywAutoLayoutView() {
        self.themeManagerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavoriteValues(_:)), name: Notification.Name(rawValue:kRefreFavoriteNotif), object: nil)
    }
    
    
    @objc func refreshFavoriteValues(_ notif:Notification) {
        
    }
    
    func requestCustomData(_ isLoadMore: Bool) {
        //odd测试数据 返回数据成功
        //self.themeManagerView.endHeaderOrFooterRefresh(!isLoadMore)
        self.recommendType = 0
        self.isChannel = false
        self.themeManagerView.clearDatas()
        
        if isLoadMore == false {
            handResult()
        }
        
        bk_delay(by: 3, qosClass: nil) {[weak self] in
            guard let `self` = self else {return}
            self.themeManagerView.showRequestTipResult()
        }
    }
    
    func handResult() {
        
        var dataSourceList:[YWCustomerLayoutSectionModuleProtocol] = []
        self.recommendDatas.removeAll()
        
        if let resultModel = self.createTestResult() {
            let modelList = resultModel.mutiProtogene
            for themeModel in modelList {
                
                if themeModel.type == 0 {
                    let singleModule = YWAsinglViewModule()
                    let advCellModel = YWAsingleCCellModel()
                    advCellModel.dataSource = themeModel.oneAdvList
                    advCellModel.bgColor = themeModel.bgColor
                    advCellModel.size = CGSize(width: KSCREEN_WIDTH, height: 120)
                    
                    singleModule.sectionDataList.append(advCellModel)
                    dataSourceList.append(singleModule)
                }
                
                if themeModel.type == 4 {
                    let singleModule = YWAsinglViewModule()
                    let advCellModel = YWAsingleCCellModel()
                    advCellModel.dataSource = themeModel.oneAdvList
                    advCellModel.bgColor = themeModel.bgColor
                    advCellModel.size = CGSize(width: KSCREEN_WIDTH, height: 200)
                    
                    singleModule.sectionDataList.append(advCellModel)
                    dataSourceList.append(singleModule)
                }
            }
            
            if self.isChannel {// 有分类导航 在里面控制 是否加载更多
                self.addFooterLoadingMore(true)
            } else {
                // 设置是否上拉加载
                let showFooter = self.recommendType > 0 ? true : false
                self.addFooterLoadingMore(showFooter)
                if showFooter {
                    self.loadActivityGoods(false)
                }
            }
        }
        
        self.themeManagerView.dataSourceList = dataSourceList
        //空视图处理
        if self.isChannel == false && self.recommendType > 0 {
            
        } else {
            
        }
        self.themeManagerView.themeCollectionView.reloadData()
        
    }
    
    
    
    /** 有些操作必须在已添加到父类视图的时候*/
    func viewDidShow() {
        
    }
    
    /** 初始化下拉刷新控件 */
    func addListViewRefresh() {
        let shouldRequest = false
        self.themeManagerView.addListHeaderRefreshBlock(headerBlock: {[weak self] in
            guard let `self` = self else {return}
            // 列表 顶部广告banner等数据
            let showLoading = self.themeManagerView.dataSourceList.count == 0
            self.requestCustomData(showLoading)
            
        }, showBannerBlock: {[weak self] in
            guard let `self` = self else {return}
            
        }, footerBlock: nil, startRefresh: false)
        if shouldRequest {
            self.themeManagerView.themeCollectionView.headerRefreshingByAnimation(false)
        }
    }
    
    func addListAnimateViewRefresh() {
        let shouldRequest = false
        self.themeManagerView.themeCollectionView.mj_header = YWRefreshAnimateHeader.init(refreshingBlock: { [weak self] in
            guard let `self` = self else { return }
            // 列表 顶部广告banner等数据
            let showLoading = self.themeManagerView.dataSourceList.count == 0
            self.requestCustomData(showLoading)
        })
    }
    
    func addFooterLoadingMore(_ showLoadingMore: Bool) {
        self.themeManagerView.addFooterLoadingMore(showLoadingMore: showLoadingMore) {[weak self] in
            guard let `self` = self else {return}
            if self.isChannel {
                self.loadMenuGoods(true)
            } else {
                self.loadActivityGoods(true)
            }
        }
    }
    
    func scrollToRecommendPosition() {
        
    }
    
    func loadMenuGoods(_ isLoadMore: Bool) {
        
        bk_delay(by: 3, qosClass: nil) {[weak self] in
            guard let `self` = self else {return}
            self.themeManagerView.endHeaderOrFooterRefresh(true)
        }
    }
    
    // 没有导航分类处理
    func loadActivityGoods(_ isLoadMore: Bool) {
        
        bk_delay(by: 3, qosClass: nil) {[weak self] in
            guard let `self` = self else {return}
            self.themeManagerView.endHeaderOrFooterRefresh(true)
        }
    }
    
    //MARK: - setter
    lazy var themeManagerView: YWThemeHandleManagerView = {
        let view = YWThemeHandleManagerView(frame: self.bounds, channelId: self.customId as NSString, showRecommend: true)
        view.delegate = self
        view.forbidCollectionRecognizeSimultaneously(true)
        return view
    }()
}

extension YWThemesMainView: YWThemeHandleManagerProtocol {
    func yw_themeManager(managerView: YWThemeHandleManagerView, collectionView: UICollectionView, eventCell: UICollectionViewCell, deepLinkItem: YWAdvsEventsModel) {
        
    }
    
    func yw_themeManager(managerView: YWThemeHandleManagerView, collectionView: UICollectionView, didSelectItemCell: UICollectionViewCell, indexPath: IndexPath) {
        
        let context = YWNavigatable(viewModel: YWVideoViewModel())
        YWWAppDelegate?.navigator.pushPath(YWModulePaths.video.url, context: context, animated: true)

    }
    
    
}

extension YWThemesMainView {
    
    func createTestResult() -> YWThemesMainsModel? {
        
        var model = YWThemesMainsModel()
        model.bg_color = "0xf5f5f5"
        model.specialName = "首页活动"
        
        var mutiProtogene:[YWThemeModulModel] = []
        
        for i in 0...7 {
            
            var groupModel:YWThemeModulModel = YWThemeModulModel()
            groupModel.type = i
            groupModel.bgColor = "0xF5F5F5"
            
            if i == 1 {
                var cycleList:[YWAdvEventSpecialModel] = []
                for j in 0...5 {
                    let advModel:YWAdvEventSpecialModel = YWAdvEventSpecialModel()
                    advModel.images = "1234"
                    advModel.name = "iii" + "\(j)"
                    advModel.url = "ywtigerkin:abc/123/"
                    cycleList.append(advModel)
                }
                groupModel.cycleAdvList = cycleList
            }
            
            if i == 2 {
                var channelList:[YWThemeCThemeChannelModel] = []
                for j in 0...6 {
                    var channelModel = YWThemeCThemeChannelModel()
                    channelModel.id = "id" + "\(j)"
                    channelModel.name = "menu" + "\(j)"
                    channelModel.categoryId = "123"+"\(j)"
                    channelModel.categoryName = "name" + "\(j)"
                    channelList.append(channelModel)
                }
                groupModel.channelList = channelList
            }
            
            if i == 4 {
                var oneAdvList:[YWAdvEventSpecialModel] = []
                for j in 0...5 {
                    
                    var oneAdvImage = YWAdvEventSpecialModel()
                    oneAdvImage.images = ""
                    oneAdvImage.imageWidth = "4.0"
                    oneAdvImage.imageHdight = "3.0"
                    oneAdvImage.url = "ywtigerkin:abc/ad"
                    oneAdvList.append(oneAdvImage)
                }
                groupModel.oneAdvList = oneAdvList
            }
            
            if i == 5 {
                var twoAdvList:[YWAdvEventSpecialModel] = []
                for j in 0..<6 {
                    let advModel = YWAdvEventSpecialModel()
                    advModel.images = ""
                    advModel.imageWidth = "4.0"
                    advModel.imageHdight = "3.0"
                    advModel.url = "ywtigerkin:abc/ad"
                    twoAdvList.append(advModel)
                }
                groupModel.twoAdvList = twoAdvList
            }
            
            if i == 5 {
                var slideList:[YWThemeCGoodsModel] = []
                for j in 0..<8 {
                    let goodsModel = YWThemeCGoodsModel()
                    goodsModel.goodsTitle = "abc" + "\(j)"
                    goodsModel.shopPrice = "$100.0"
                    goodsModel.marketPrice = "$120.0"
                    goodsModel.goodsId = "id" + "\(j)"
                    goodsModel.goodsSku = "sku" + "\(j)"
                    slideList.append(goodsModel)
                }
                groupModel.slideList = slideList
            }
            
            mutiProtogene.append(groupModel)
        }
        model.mutiProtogene = mutiProtogene
        return model
    }
}
