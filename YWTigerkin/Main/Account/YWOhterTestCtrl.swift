//
//  YWOhterTestCtrl.swift
//  YWTigerkin
//
//  Created by odd on 6/18/23.
//

import UIKit

class YWOhterTestCtrl: YWBaseViewController , HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWOtherTestViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ohter"
        
        bindViewModel()
        viewModelResponse()
        bindHUD()
        
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(16)
            make.right.equalTo(self.view.snp.right).offset(-16)
            make.top.equalTo(self.view.snp.top).offset(12)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        self.addRefreshHeader()
        self.viewModel.requestData()
    }
    func addRefreshHeader() {
        tableView.addHeaderRefreshBlock(headerBlock: {[weak self] in
            guard let `self` = self else {return}
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.tableView.reloadData()
                //self.tableView.mj_header.endRefreshing()
                self.tableView.showRequestTip([kTotalPageKey:"2",kCurrentPageKye:"1"])
//                self.tableView.showRequestTip(nil)

            })
        }, footerBlock: {
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.tableView.reloadData()
                //self.tableView.mj_header.endRefreshing()
//                self.tableView.showRequestTip(nil)
                self.tableView.showRequestTip([kTotalPageKey:"1",kCurrentPageKye:"1"])


            })
        }, startRefreshing: false)
    }
    
    lazy var tableView:UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(YWAccountCell.self, forCellReuseIdentifier: NSStringFromClass(YWAccountCell.self))
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        if #available(iOS 11, *) {
            view.estimatedRowHeight = 56.0
            view.estimatedSectionFooterHeight = 0
            view.estimatedSectionHeaderHeight = 0
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    lazy var htmBtn: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("go htmWeb", for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        view.backgroundColor = UIColor.random
        view.addTarget(self, action: #selector(webAction), for: .touchUpInside)
        return view
    }()
    
    lazy var searchBtn: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("go Search", for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        view.backgroundColor = UIColor.random
        view.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return view
    }()
    
    @objc func webAction() {
        
        let webCtrl = YWWebHtmlImageCtrl()
        
        self.navigationController?.pushViewController(webCtrl, animated: true)
    }
    
    @objc func searchAction() {
        
        self.viewModel.navigator.push(YWModulePaths.search.url)
    }

    @objc func payAction() {
        
        let payViewModel = YWApplePayViewModel()
        let context = YWNavigatable(viewModel: payViewModel)

        self.viewModel.navigator.pushPath(YWModulePaths.payCenter.url, context: context, animated: true)
    }
    override func viewModelResponse() {
        
        self.viewModel.accountSubject.subscribe(onNext: { [weak self] success in
            guard let `self` = self else {return}
            self.view.endEditing(true)
            if success {
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
    }

}

extension YWOhterTestCtrl: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YWAccountCell.self), for: indexPath) as! YWAccountCell
        if self.viewModel.datas.count > indexPath.row {
            let model = self.viewModel.datas[indexPath.row]
            cell.model = model
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.datas.count > indexPath.row {
            let model = self.viewModel.datas[indexPath.row]
            if model.id == "0" {
                self.payAction()
            } else if model.id == "1" {
                let context = YWNavigatable(viewModel: YWVideoViewModel())
                YWAppDelegate?.navigator.pushPath(YWModulePaths.video.url, context: context, animated: true)
            } else if model.id == "2" {
                let context = YWNavigatable(viewModel: YWDouYinVideoViewModel(), userInfo: ["type":"1"])
                self.viewModel.navigator.pushPath(YWModulePaths.douYinVidoe.url, context: context, animated: true)
            } else if model.id == "5" {
                let webModel = YWWebViewModel(dictionary: [:])
                webModel.url = "https://baidu.com/"
                let context = YWNavigatable(viewModel: webModel)
                YWAppDelegate?.navigator.pushPath(YWModulePaths.webPage.url, context: context, animated: true)
            }
        }
        return;
    }
    
}
