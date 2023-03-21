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

class YWAccountCtrl: YWBaseViewController, HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWAccountViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "account"
        
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
        
        self.viewModel.requestData()
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

    func viewModelResponse() {
        
        self.viewModel.accountSubject.subscribe(onNext: { [weak self] success in
            guard let `self` = self else {return}
            self.view.endEditing(true)
            if success {
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
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
    
    
}
