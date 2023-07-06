//
//  YWApplePayCtrl.swift
//  YWTigerkin
//
//  Created by odd on 6/18/23.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class YWApplePayCtrl: YWBaseViewController, HUDViewModelBased {

    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    var viewModel: YWApplePayViewModel!

    lazy var payButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle(">>购买<<", for:.normal)
        view.addTarget(self, action: #selector(payAction), for: .touchUpInside)
        view.backgroundColor = UIColor.random
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付"
        bindHUD()
        bindViewModel()
        viewModelResponse()
        
        self.view.addSubview(payButton)
        payButton.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }
    
    
    @objc func payAction() {
        
        let productModel = YWApplePayProduct()
        productModel.productId = "appstore_product_id"
        self.viewModel.hudSubject.onNext(.loading(nil, true))
        YWApplePayManager.pay(product: productModel) {[weak self] resutlInfo in
            guard let `self` = self else {return}
            self.viewModel.hudSubject.onNext(.hide)
            if resutlInfo.isSuccess {
                
            } else {
                //
                print("支付失败：\(resutlInfo.logMsg)")
                self.viewModel.hudSubject.onNext(.message(resutlInfo.logMsg, true))
            }
        }
    }

    override func viewModelResponse() {
        
        
    }
    
    override func bindViewModel() {
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
