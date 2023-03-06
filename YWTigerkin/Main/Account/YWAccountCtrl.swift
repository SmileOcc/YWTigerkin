//
//  YWAccountCtrl.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit

class YWAccountCtrl: YWBaseViewController, YWViewModelBased{
    
    var viewModel: YWAccountViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "account"
        // Do any additional setup after loading the view.
        
        self.view.addSubview(htmBtn)
        self.view.addSubview(searchBtn)

        htmBtn.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(16)
            make.top.equalTo(self.view.snp.top).offset(120)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(16)
            make.top.equalTo(self.view.snp.top).offset(160)
        }
    }
    
    
    lazy var htmBtn: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("htmWeb", for: .normal)
        view.backgroundColor = UIColor.yellow
        view.addTarget(self, action: #selector(webAction), for: .touchUpInside)
        return view
    }()
    
    lazy var searchBtn: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Search", for: .normal)
        view.backgroundColor = UIColor.yellow
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
