//
//  YWSettingCtrl.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import UIKit

class YWSettingCtrl: YWBaseViewController , HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWSettingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        
        self.viewModel.language = YWUserManager.curLanguage()

        bindViewModel()
        viewModelResponse()
        bindHUD()
        
        self.tableView.tableFooterView = footerView
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(16)
            make.right.equalTo(self.view.snp.right).offset(-16)
            make.top.equalTo(self.view.snp.top).offset(12)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        self.viewModel.requestData()
    }
    
    lazy var footerView:YWSettingFooterView = {
        let view = Init(YWSettingFooterView(frame: CGRect.zero), block: {
            $0.frame = CGRect.init(x: 0, y: 0, width: YWConstant.screenWidth, height: 70)
            $0.logoutBlock = {[weak self] in
                guard let `self` = self else {return}
                self.logoutAction()
            }
        })
        return view
    }()
    
    lazy var tableView:UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(YWAccountCell.self, forCellReuseIdentifier: NSStringFromClass(YWAccountCell.self))
        view.separatorStyle = .none
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
    
    @objc func logoutAction() {
        
        YWAlertView.showAlert(frame: UIScreen.main.bounds, alertType: STLAlertType.button, isVertical: true, messageAlignment: .center, isAr: false, showHeightIndex: 1, title: nil, message: YWLanguageTool("sureSignOut"), buttonTitles: [YWLanguageTool("cancel").uppercased(),YWLanguageTool("sure").uppercased()]) { flag, _ in
            if flag == 1 {
                
                YWUserManager.loginOut(request: true)
            }
        }
    }
    
    @objc func webAction() {
        
        let webCtrl = YWWebHtmlImageCtrl()
        
        self.navigationController?.pushViewController(webCtrl, animated: true)
    }
    
    @objc func webNavAction() {
        let webCtrl = YWNativeWebCtrl()
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

extension YWSettingCtrl: UITableViewDelegate,UITableViewDataSource {
    
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
            if model.id == "0" {//切换语言
                
                self.showLanguageAlert()
            } else if model.id == "1" {//版本更新
                YWUpdateManager.shared.showUpdateAlert()

            } else if model.id == "2" {
                let addressModel = YWAddressListViewModel()
                let context = YWNavigatable(viewModel: addressModel)
                YWWAppDelegate?.navigator.pushPath(YWModulePaths.addressCenter.url, context: context, animated: true)
            } else if model.id == "5" {
                let webModel = YWWebViewModel(dictionary: [:])
                webModel.url = "https://baidu.com/"
                let context = YWNavigatable(viewModel: webModel)
                YWWAppDelegate?.navigator.pushPath(YWModulePaths.webPage.url, context: context, animated: true)
            }
        }
        return;
    }
}

extension YWSettingCtrl {
    
    func showLanguageAlert() {
        
        let languageView = YWLanguageAlertView(frame: CGRect.init(x: 0, y: 0, width: YWConstant.screenWidth, height: YWConstant.screenHeight), curLanguage: self.viewModel.language)
        languageView.didSelected = {[weak self] index in
            guard let `self` = self else {return}
            
            switch index {
            case 2:
                self.viewModel.language = .EN
            case 1:
                self.viewModel.language = .CN
            default:
                self.viewModel.language = .HK
            }
            //self.viewModel.configType = .language
            //存储和更新
            MMKV.default()?.set(Int32(self.viewModel.language.rawValue), forKey: YWUserManager.YWLanguage)
//            if YWUserManager.isLogin() {
                //self.requestUserConfig()
//            } else {
            YWLanguageUtility.resetUserLanguage(self.viewModel.language)
                NotificationCenter.default.post(name: NSNotification.Name(YWUserManager.notiUpdateResetRootView), object: nil)
//            }
        }
        languageView.showAlert()

    }
}
