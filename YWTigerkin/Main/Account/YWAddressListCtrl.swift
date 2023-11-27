//
//  YWAddressListCtrl.swift
//  YWTigerkin
//
//  Created by odd on 11/27/23.
//

import UIKit

class YWAddressListCtrl: YWBaseViewController , HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWAddressListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "地址列表"
        
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
            }
        })
        return view
    }()
    
    lazy var tableView:UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(YWAddressListCell.self, forCellReuseIdentifier: NSStringFromClass(YWAddressListCell.self))
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        
        view.estimatedRowHeight = 56.0
        view.estimatedSectionFooterHeight = 0
        view.estimatedSectionHeaderHeight = 0
        view.contentInsetAdjustmentBehavior = .never

        
        return view
    }()
    
    
    override func viewModelResponse() {
        
        self.viewModel.successSubject.subscribe(onNext: { [weak self] success in
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

extension YWAddressListCtrl: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YWAddressListCell.self), for: indexPath) as! YWAddressListCell
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
        let editViewModel = YWAddressEditViewModel()
        
        let context = YWNavigatable(viewModel: editViewModel)
        self.viewModel.navigator.pushPath(YWModulePaths.addressEdit.url, context: context, animated: true)
    }
}

