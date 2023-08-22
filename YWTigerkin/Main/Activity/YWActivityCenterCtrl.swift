//
//  YWActivityCenterCtrl.swift
//  YWTigerkin
//
//  Created by odd on 8/17/23.
//

import UIKit

import Reusable
import RxSwift
import RxCocoa
import SHFullscreenPopGestureSwift

import JXPagingView
import JXSegmentedView

class YWActivityCenterCtrl: YWBaseViewController, HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWActivityCenterViewModel!
    
    var titleMenus:[YWActivityCenterMenuModel] = []
    var childCtrls:[YWActivityCenterItemCtrl] = []
    
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
    lazy var pagingView: JXPagingView = JXPagingView(delegate: self)
    
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: YWConstant.screenWidth, height: CGFloat(headerInSectionHeight)))
        return view
    }()
//    var dataSource = JXSegmentedTitleDataSource()
    // 数字
    lazy var dataSource:JXSegmentedNumberDataSource = {
       let data = JXSegmentedNumberDataSource()
        data.numbers = [0,11,120]
        return data
    }()
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

        self.titleMenus = [YWActivityCenterType.all,YWActivityCenterType.hot,YWActivityCenterType.pick].reduce(into: [YWActivityCenterMenuModel](), {
            let menuModel = YWActivityCenterMenuModel(title: $1.title, id: "id_\($1.rawValue)")
            $0.append(menuModel)
        })
        
        self.childCtrls = self.titleMenus.reduce(into: [YWActivityCenterItemCtrl](), {
            
            let model = YWActivityCenterItemViewModel()
            model.menuId = $1.id ?? ""
            let ctrl = YWActivityCenterItemCtrl.instantiate(withViewModel: model, andServices: self.viewModel.services, andNavigator: self.viewModel.navigator)
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
        
        pagingView.pinSectionHeaderVerticalOffset = pagingViewPinSectionHeaderVerticalOffset
        
        
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
        self.pagingView.mainTableView.addHeaderRefreshBlock(headerBlock: {[weak self] in
            guard let `self` = self else {return}

            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.pagingView.mainTableView.reloadData()
                //self.tableView.mj_header.endRefreshing()
                self.pagingView.mainTableView.showRequestTip([kTotalPageKey:"2",kCurrentPageKye:"1"])
//                self.tableView.showRequestTip(nil)

            })
        }, footerBlock: nil, startRefreshing: false)
    }
}
///JXpagingView代理方法
extension YWActivityCenterCtrl: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        ///上方头部高度
        return headerViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        ///上方头部View（我这里使用的自定义View，建议提出单独写View）
        return userHeaderView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        ///上滑移动最大偏移量（大于这个偏移量就无法再上滑）
        return headerInSectionHeight
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        ///分类文章标题View
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        ///分类标题个数
        return titles.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        self.childCtrls[index]
    }

    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        YWLog("1----\(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y >= (150.0 - YWConstant.statusBarHeight) {
            YWLog("----\(scrollView.contentOffset.y)")
            self.blankView.isHidden = false
        } else {
            self.blankView.isHidden = true
        }
    }

}

extension YWActivityCenterCtrl: JXSegmentedViewDelegate {
    ///默认的分类标题选择项
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
}

/// 需要将JXPagingListContainerView继承JXSegmentedViewListContainer，不然会报错，开发文档中也有所提及
//extension JXPagingListContainerView: JXSegmentedViewListContainer {}
