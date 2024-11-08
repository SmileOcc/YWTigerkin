//
//  YWSearchResultCtrl.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import UIKit

class YWSearchResultCtrl: YWBaseViewController, HUDViewModelBased{
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWSearchResultViewModel!

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
