//
//  YWAccountCenterItemCtrl.swift
//  YWTigerkin
//
//  Created by odd on 8/13/23.
//

import UIKit
import Reusable
import RxSwift

import RxCocoa
import SHFullscreenPopGestureSwift

import JXPagingView
//JXPagingSmoothViewListViewDelegate

//class YWAccountCenterItemCtrl: YWBaseViewController, HUDViewModelBased, JXPagingViewListViewDelegate{
    
class YWAccountCenterItemCtrl: YWBaseViewController, HUDViewModelBased, JXPagingSmoothViewListViewDelegate{

    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWAccountCenterItemViewModel!

    ///三个子控制器需要添加的代理方法
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        ///传入带有UIScrollView的组件，可以进行滚动
        return self.myTableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        ///这个比较重要，可以将父控制器的上下滚动传递进来
        self.scrollCallback = callback
    }
    
    private var myTableView: UITableView!
    
    private var productList = [YWAccountCenterItemModel]()
    
    /// scrollView回调
    var scrollCallback:((UIScrollView) -> Void)?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sh_prefersNavigationBarHidden = true

        bindViewModel()
        viewModelResponse()
        bindHUD()
        
        self.initView()
        self.setupLayout()
        
        
    }
    private func initView() {
        //self.view.backgroundColor = YWThemesColors.col_F7F7F7
        
        myTableView = UITableView(frame: .zero, style: .plain)
        myTableView.backgroundColor = YWThemesColors.col_F7F7F7
        myTableView.showsVerticalScrollIndicator = false
        myTableView.separatorStyle = .none
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.register(YWAccountCenterItemCell.self, forCellReuseIdentifier: NSStringFromClass(YWAccountCenterItemCell.self))
        
        self.view.addSubview(myTableView)
        
    }
    
    private func setupLayout() {
        myTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
    
}

///下面就是常规的UITableView代理方法
extension YWAccountCenterItemCtrl: UITableViewDelegate,
                                   UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YWAccountCenterItemCell.self), for: indexPath) as! YWAccountCenterItemCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.random
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    ///记得加上ScrollView的回调
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollCallback?(scrollView)
    }
}

