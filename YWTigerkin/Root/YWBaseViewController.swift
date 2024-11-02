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
    
    lazy var baseNavBar:YWNavBarBaseView = {
        let view = YWNavBarBaseView(frame: CGRect.zero)
        view.isHidden = true
        view.backgroundColor = UIColor.random
        view.backBlock = {[weak self] in
            guard let `self` = self else {return}
            self.goBackAction()
        }
        return view
    }()
    
    lazy var testMessageLab:UILabel = {
        let view = UILabel(frame:CGRect.zero)
        view.backgroundColor = UIColor.green
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 13)
        view.numberOfLines = 0
        view.isHidden = true
        return view
    }()
    
    lazy var testBtn:UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle(" 测试按钮 ", for: .normal)
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(testAction), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if YWWAppDelegate?.screen_set != .set_port {
            YWScreenTool().switchScreenOrientation(vc: self, mode: self.isSupportedOrientations())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if YWWAppDelegate?.screen_set != .set_port || self.view.frame.size.width > self.view.frame.size.height {
            YWScreenTool().switchScreenOrientation(vc: self, mode: self.isSupportedOrientations())
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexColor("0xeeeeee")
        self.modalPresentationStyle = .fullScreen

        self.view.addSubview(baseNavBar)
        
        self.view.addSubview(testMessageLab)
        self.view.addSubview(testBtn)
        
        baseNavBar.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(YWConstant.navBarHeight)
        }
        
        testMessageLab.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.baseNavBar.snp.bottom).offset(12)
            make.height.greaterThanOrEqualTo(44)
        }
        
        testBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).offset(-50)
        }
        
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: YWUserManager.notiRefreshDataView))
            .take(until: self.rx.deallocated)
            .subscribe(onNext: { [weak self] (ntf) in
                guard let `self` = self else { return }
                
                self.refreshLoginInfoAction()

            })
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(YWUserManager.notiLogin))
            .subscribe(onNext: { [weak self] notification in
                
            }).disposed(by: rx.disposeBag)
    }
    
    func bindViewModel() {
        
    }
    
    func viewModelResponse() {
//        viewModel.loginSuccessSubject.subscribe(onNext: {[weak self] (success) in
//            guard let `self` = self else {return}
//
//        }).disposed(by: disposeBag)
    }
    
    //
    @objc func refreshLoginInfoAction() {
        
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
    
    
    
    
    func isSupportedOrientations() -> SCREEN_SET {
        if self is YWVideoCtrl {
            return .set_auto
        }
        return .set_port
    }

    /// 监听视图变化。在此处对控件重新约束。
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        /// 判断横竖屏
        if size.width > size.height {
            /// 这是横屏
        } else {
            /// 这是竖屏
                }
    }

    
    @objc func testAction() {
    }
    
    
}
