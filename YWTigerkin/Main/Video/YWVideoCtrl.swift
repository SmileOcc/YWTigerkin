//
//  YWVideoCtrl.swift
//  YWTigerkin
//
//  Created by odd on 4/18/23.
//

import UIKit
import SHFullscreenPopGestureSwift

class YWVideoCtrl: YWBaseViewController, HUDViewModelBased {

    var viewModel: YWVideoViewModel!
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sh_prefersNavigationBarHidden = true
        self.sh_interactivePopDisabled = true
        
        self.baseNavBar.title = "视频"
        self.baseNavBar.isHidden = false
        
        view.addSubview(floatView)
        floatView.addSubview(floatButton)
        
        floatView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-(YWConstant.safeBottom + 16))
            make.size.equalTo(CGSize(width: 56.0, height: 56.0))
        }
        
        floatButton.snp.makeConstraints { make in
            make.centerX.equalTo(floatView.snp.centerX)
            make.centerY.equalTo(floatView.snp.centerY)
        }
    }
    
    
    @objc func changeAction() {
        

        if YWScreenTool.isPortrait() {
            YWScreenTool.interfaceOrientation(isPortrait: false)

        } else {
            YWScreenTool.interfaceOrientation(isPortrait: true)
        }
    }

    
    // MARK: - setter
    
    lazy var floatView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.random
        view.layer.cornerRadius = 28.0
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var floatButton:UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("横屏查看", for: .normal)
        view.titleLabel?.font = UIFont.mediumFont(12)
        view.addTarget(self, action: #selector(changeAction), for: .touchUpInside)
        return view
    }()

    
    /// 监听视图变化。在此处对控件重新约束。
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        /// 判断横竖屏
        if size.width > size.height {
            /// 这是横屏
            self.floatButton.setTitle("竖屏查看", for: .normal)
        } else {
            /// 这是竖屏
            self.floatButton.setTitle("横屏查看", for: .normal)

                }
    }

}
