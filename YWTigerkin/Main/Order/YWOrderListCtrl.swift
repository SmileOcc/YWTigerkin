//
//  YWOrderListCtrl.swift
//  YWTigerkin
//
//  Created by odd on 8/12/23.
//

import UIKit

class YWOrderListCtrl: YWBaseViewController, HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWOrderItemListViewModel!

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
