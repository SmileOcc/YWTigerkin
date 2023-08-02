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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if YWAppDelegate?.screen_set != .set_port {
            YWScreenTool().switchScreenOrientation(vc: self, mode: self.isSupportedOrientations())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if YWAppDelegate?.screen_set != .set_port || self.view.frame.size.width > self.view.frame.size.height {
            YWScreenTool().switchScreenOrientation(vc: self, mode: self.isSupportedOrientations())
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexColor("0xeeeeee")
        self.modalPresentationStyle = .fullScreen

        self.view.addSubview(baseNavBar)
        baseNavBar.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(YWConstant.navBarHeight)
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

    
    
}
