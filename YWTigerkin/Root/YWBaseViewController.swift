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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "YW"
        self.view.backgroundColor = UIColor.random
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
