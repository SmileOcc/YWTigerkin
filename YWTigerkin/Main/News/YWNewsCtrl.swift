//
//  YWNewsCtrl.swift
//  YWTigerkin
//
//  Created by odd on 8/1/23.
//

import UIKit

class YWNewsCtrl: YWBaseViewController , HUDViewModelBased{

    var viewModel: YWNewsViewModel!
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindHUD()
        self.bindViewModel()
    }
}
