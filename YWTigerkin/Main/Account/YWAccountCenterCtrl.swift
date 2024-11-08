//
//  YWAccountCenterCtrl.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import SHFullscreenPopGestureSwift

import JXPagingView
import JXSegmentedView

class YWAccountCenterCtrl: YWBaseViewController, HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWAccountCenterViewModel!
    
    var titleMenus:[YWAccountCenterMenuModel] = []
    var childCtrls:[YWAccountCenterItemCtrl] = []
    
    lazy var userHeaderView: UIView = {
        let view = Init(UIView(frame: CGRect(x: 0, y: 0, width: Int(YWConstant.screenWidth), height: self.headerViewHeight)), block: {
            $0.backgroundColor = YWThemesColors.col_themeColor_03
        })
        return view
    }()

    ///这里上滑触顶的时候，状态栏为透明色
    private var blankView = UIView()
    
    //JXPagingSmoothView 刷新在顶部
    //JXPagingView 刷新在字控制器
    lazy var pagingView: JXPagingSmoothView = {
       let view = JXPagingSmoothView(dataSource: self)
        view.delegate = self
        return view
    }()
    
    lazy var segmentedView: JXSegmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: YWConstant.screenWidth, height: CGFloat(headerInSectionHeight)))
    var dataSource = JXSegmentedTitleDataSource()
    var titles = ["热门", "最新", "全部"]
    
    ///分类上方头部高度
    private var headerViewHeight: Int = Int(150)
    ///分类标题高度
    private var headerInSectionHeight: Int = Int(52)
    ///上滑触顶偏移量
    private var pagingViewPinSectionHeaderVerticalOffset: Int = Int(YWConstant.statusBarHeight)
     
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sh_prefersNavigationBarHidden = true

        self.titleMenus = [YWAccountCenterType.all,YWAccountCenterType.hot,YWAccountCenterType.pick].reduce(into: [YWAccountCenterMenuModel](), {
            let menuModel = YWAccountCenterMenuModel(title: $1.title, id: "id_\($1.rawValue)")
            $0.append(menuModel)
        })
        
        self.childCtrls = self.titleMenus.reduce(into: [YWAccountCenterItemCtrl](), {
            
            let model = YWAccountCenterItemViewModel()
            model.menuId = $1.id ?? ""
            let ctrl = YWAccountCenterItemCtrl.instantiate(withViewModel: model, andServices: self.viewModel.services, andNavigator: self.viewModel.navigator)
            $0.append(ctrl)
        })
        bindViewModel()
        viewModelResponse()
        bindHUD()
        
        self.view.backgroundColor = YWThemesColors.col_F7F7F7
        blankView.backgroundColor = YWThemesColors.col_F7F7F7
        
        ///分类标题栏数据内容
        dataSource.titles = titles
        dataSource.titleSelectedColor = UIColor.hexColor("0x24292B")
        dataSource.titleNormalColor = UIColor.hexColor("0x9DA2A5")
        dataSource.titleNormalFont = .fscMedium(16)
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = false
        
        segmentedView.backgroundColor = YWThemesColors.col_F7F7F7
        segmentedView.delegate = self
        segmentedView.dataSource = dataSource
        //segmentedView.listContainer = pagingView.listContainerView
        
        //扣边返回处理，下面的代码要加上（demo中展示需加上）
//        pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
//        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
//        pagingView.currentListInitializeContentOffsetY = CGFloat(pagingViewPinSectionHeaderVerticalOffset)
//
        
        pagingView.backgroundColor = YWThemesColors.col_F7F7F7
        
        self.view.addSubview(pagingView)
        self.view.addSubview(blankView)
        self.blankView.isHidden = true
    
        self.setupLayout()
        
        self.addRefreshHeader()
        self.viewModel.requestData()
        
    }
    
    private func setupLayout() {
        pagingView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(YWConstant.screenWidth)
            make.height.equalTo(YWConstant.screenHeight)
        }
        
        blankView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(YWConstant.screenWidth)
            make.height.equalTo(YWConstant.statusBarHeight)
        }
    }

    func addRefreshHeader() {
//        tableView.addHeaderRefreshBlock(headerBlock: {[weak self] in
//            guard let `self` = self else {return}
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                self.tableView.reloadData()
//                //self.tableView.mj_header.endRefreshing()
//                self.tableView.showRequestTip([kTotalPageKey:"2",kCurrentPageKye:"1"])
////                self.tableView.showRequestTip(nil)
//
//            })
//        }, footerBlock: {
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                self.tableView.reloadData()
//                //self.tableView.mj_header.endRefreshing()
////                self.tableView.showRequestTip(nil)
//                self.tableView.showRequestTip([kTotalPageKey:"1",kCurrentPageKye:"1"])
//
//
//            })
//        }, startRefreshing: false)
    }
}
// JXPagingSmoothViewDataSource
///JXpagingView代理方法

extension YWAccountCenterCtrl: JXPagingSmoothViewDataSource {
    func heightForPagingHeader(in pagingView: JXPagingSmoothView) -> CGFloat {
        return CGFloat(headerViewHeight)
    }
    
    func viewForPagingHeader(in pagingView: JXPagingSmoothView) -> UIView {
        return userHeaderView

    }
    
    func heightForPinHeader(in pagingView: JXPagingSmoothView) -> CGFloat {
        return CGFloat(headerInSectionHeight)

    }
    
    func viewForPinHeader(in pagingView: JXPagingSmoothView) -> UIView {
        return segmentedView

    }
    
    func numberOfLists(in pagingView: JXPagingSmoothView) -> Int {
        ///分类标题个数
        return titles.count
    }
    
    func pagingView(_ pagingView: JXPagingSmoothView, initListAtIndex index: Int) -> JXPagingSmoothViewListViewDelegate {
        self.childCtrls[index]
    }
}

extension YWAccountCenterCtrl: JXPagingSmoothViewDelegate {
    func pagingSmoothViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (150.0 - YWConstant.statusBarHeight) {
            YWLog("----\(scrollView.contentOffset.y)")
            self.blankView.isHidden = false
        } else {
            YWLog("+++++\(scrollView.contentOffset.y)")
            self.blankView.isHidden = true
        }
    }
}


extension YWAccountCenterCtrl: JXSegmentedViewDelegate {
    ///默认的分类标题选择项
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
}

/// 需要将JXPagingListContainerView继承JXSegmentedViewListContainer，不然会报错，开发文档中也有所提及
extension JXPagingListContainerView: JXSegmentedViewListContainer {}
