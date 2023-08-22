//
//  YWSearchCtrl.swift
//  YWTigerkin
//
//  Created by odd on 3/3/23.
//

import UIKit

class YWSearchCtrl: YWBaseViewController, HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWSearchViewModel!

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
