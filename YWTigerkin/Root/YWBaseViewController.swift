//
//  YWBaseViewController.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx


class YWBaseViewController: UIViewController, HasDisposeBag {

    deinit {
        print(">>>>>>> \(NSStringFromClass(type(of: self)).split(separator: ".").last!) deinit")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "YW"
        self.view.backgroundColor = UIColor.hexColor("0xeeeeee")
    }
    
    func bindViewModel() {
        
    }
    
    func viewModelResponse() {
//        viewModel.loginSuccessSubject.subscribe(onNext: {[weak self] (success) in
//            guard let `self` = self else {return}
//
//        }).disposed(by: disposeBag)
    }
    @objc func goBackAction() {
        if let viewControllers = self.navigationController?.viewControllers, viewControllers.count > 1 {
            if viewControllers.last == self {
                self.navigationController?.popViewController(animated: true)
                return
            }
        }
        self.dismiss(animated: true, completion: nil)
   
    }

}
