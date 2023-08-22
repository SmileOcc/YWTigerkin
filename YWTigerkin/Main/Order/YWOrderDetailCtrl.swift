//
//  YWOrderDetailCtrl.swift
//  YWTigerkin
//
//  Created by odd on 8/12/23.
//

import UIKit

class YWOrderDetailCtrl: YWBaseViewController, HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWOrderDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModelResponse()
        bindHUD()
        
    }
    
    override func viewModelResponse() {
        
        
    }
    
    override func bindViewModel() {
    }

}
