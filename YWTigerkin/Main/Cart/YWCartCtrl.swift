//
//  YWCartCtrl.swift
//  YWTigerkin
//
//  Created by odd on 8/12/23.
//

import UIKit

class YWCartCtrl: YWBaseViewController , HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWCartViewModel!

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
