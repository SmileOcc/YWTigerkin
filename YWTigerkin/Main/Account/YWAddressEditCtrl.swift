//
//  YWAddressEditCtrl.swift
//  YWTigerkin
//
//  Created by odd on 11/27/23.
//

import UIKit

class YWAddressEditCtrl: YWBaseViewController , HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWAddressEditViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "地址新增/编辑"
        
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
        view.register(YWAddressItemEditCell.self, forCellReuseIdentifier: NSStringFromClass(YWAddressItemEditCell.self))
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
    
    func updateCell(cell:YWAddressItemBaseCell,model:YWAddressItemEditModel) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

}

extension YWAddressEditCtrl: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YWAddressItemEditCell.self), for: indexPath) as! YWAddressItemEditCell
        if self.viewModel.datas.count > indexPath.row {
            let model = self.viewModel.datas[indexPath.row]
            cell.model = model
            
            cell.didchangeBlock = {[weak self] (tcell,model) in
                guard let `self` = self else {return}
                self.updateCell(cell: tcell, model: model)
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.viewModel.datas.count > indexPath.row {
            let model = self.viewModel.datas[indexPath.row]
            return model.contentH
        }
        return 56.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

