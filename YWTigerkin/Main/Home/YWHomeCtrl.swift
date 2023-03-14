//
//  YWHomeCtrl.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit
import Then

class YWHomeCtrl: YWBaseViewController, YWViewModelBased{
    
    var viewModel: YWHomeViewModel!

    let label = UILabel().then {
      $0.textAlignment = .center
      $0.textColor = .black
      $0.text = "Hello, World!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "home"
        // Do any additional setup after loading the view.
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
