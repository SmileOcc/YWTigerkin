//
//  YWAccountCtrl.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import SHFullscreenPopGestureSwift

class YWAccountCtrl: YWBaseViewController, HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWAccountViewModel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.upateAccountInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sh_prefersNavigationBarHidden = true

        bindViewModel()
        viewModelResponse()
        bindHUD()
        
        
        self.tableView.tableHeaderView = self.tableHeaderView
        self.view.addSubview(headerBgView)
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        self.addRefreshHeader()
        self.viewModel.requestData()
    }
    func addRefreshHeader() {
        tableView.addHeaderRefreshBlock(headerBlock: {[weak self] in
            guard let `self` = self else {return}
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
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
    
    lazy var headerBgView: UIView = {
        let view = Init(UIView(), block: {
            $0.frame = CGRect.init(x: 0, y: 0, width: YWConstant.screenWidth, height: 290)
        })
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let thisBlueColor1 = YWThemesColors.col_themeColor.cgColor
        let thisBlueColor = YWThemesColors.col_themeColor.withAlphaComponent(0.0).cgColor
        gradientLayer.colors = [thisBlueColor1,
                                thisBlueColor]
        let gradientLocations:[NSNumber] = [0.0,1.0]
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1)
        
        view.layer.addSublayer(gradientLayer)
        
        return view
    }()
    
    lazy var tableHeaderView: YWAccountHeaderView = {
        let view = YWAccountHeaderView(frame: CGRect.init(x: 0, y: 0, width: YWConstant.screenWidth, height: 200))
        view.backgroundColor = UIColor.clear
        view.loginBlock = {[weak self] in
            guard let `self` = self else {return}
            self.loginAction()
        }
        view.settingBlock = {[weak self] in
            guard let `self` = self else {return}
            self.settingAction()
            
        }
        return view
    }()
    
    lazy var tableView:UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(YWAccountCell.self, forCellReuseIdentifier: NSStringFromClass(YWAccountCell.self))
        view.separatorStyle = .none
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        
        view.estimatedRowHeight = 56.0
        view.estimatedSectionFooterHeight = 0
        view.estimatedSectionHeaderHeight = 0
        view.contentInsetAdjustmentBehavior = .never
        
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
    
    //MARK: - action
    override func refreshLoginInfoAction() {
        super.refreshLoginInfoAction()
        
        self.upateAccountInfo()
    }
    
    @objc func upateAccountInfo() {
        
        if YWUserManager.isLogin() {
            self.tableHeaderView.testIsLogin = true

        } else {
            self.tableHeaderView.testIsLogin = false

        }
    }
    
    @objc func webAction() {
        
        let webCtrl = YWWebHtmlImageCtrl()
        
        self.navigationController?.pushViewController(webCtrl, animated: true)
    }
    
    @objc func searchAction() {
        
        self.viewModel.navigator.push(YWModulePaths.search.url)
    }
    
    @objc func loginAction() {
        let loginViewModel = YWLoginViewModel(callBack: nil, vc: nil)
        let context = YWNavigatable(viewModel: loginViewModel)

        self.viewModel.navigator.presentPath(YWModulePaths.login.url, context: context, animated: true)
    }
    
    @objc func settingAction() {
        
        YWUserManager.checkLogin({[weak self] isLogin in
            guard let `self` = self else {return}
            if isLogin {
                let settingViewModel = YWSettingViewModel()
                let context = YWNavigatable(viewModel: settingViewModel)
                self.viewModel.navigator.pushPath(YWModulePaths.userCenterSet.url, context: context, animated: true)
            }
        }, isLogin: true)
        
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

extension YWAccountCtrl: UITableViewDelegate,UITableViewDataSource {
    
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
            if model.id == "2" {
              
//                let config = YWShareConfig()
//                config.title = "title"
//                config.desc = "desc"
//                config.pageUrl = "https://baidu.com"
//                config.thirdItems = [.wechat,.sinaweibo,.QQ,.facebook,.twitter,.telegram,.instagram]
//                config.toolsItems = [.ywuSocial,.ywSaveImage,.ywCopy,.ywMore]
//                config.shareType = .image
//                config.imageData = self.view.xz_snapshotImage
//                YWShareManager.shared.share(config) {[weak self] (platform, result, onlyTap) in
//                    guard let `self` = self else {return}
//                    print("分享平台：\(platform) 是否点击:\(onlyTap)")
//                    if onlyTap == true {
//                        
//                    }
//                }
                return
            }
            if model.id == "5" {
                self.goOtherAction()
            }
        }
        return;
        searchAction()
    }
    
    func goOtherAction() {
        let otherViewModel = YWOtherTestViewModel()
        let context = YWNavigatable(viewModel: otherViewModel)

        self.viewModel.navigator.pushPath(YWModulePaths.settingOther.url, context: context, animated: true)
    }
    
}
