//
//  YWNavigationViewController.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit

class YWNavigationViewController: UINavigationController , UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.view.backgroundColor = UIColor.white
        
        self.modalPresentationStyle = .fullScreen
        self.navigationBar.isTranslucent = false
        self.navigationBar.barStyle = .default
        
        if #available(iOS 15.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.configureWithOpaqueBackground()
            barApp.backgroundColor = UIColor.white
            barApp.shadowImage = UIImage()
            barApp.shadowColor = UIColor.clear
            self.navigationBar.scrollEdgeAppearance = barApp
            self.navigationBar.standardAppearance = barApp
            
            UINavigationBar.appearance().standardAppearance = barApp
            UINavigationBar.appearance().scrollEdgeAppearance = barApp
        }
        
        navigationBar.backIndicatorImage = UIImage.init(named: "nav_back")
    }
    
//    override func didShowViewController(_ viewController: UIViewController, animated: Bool) {
//        super.didShowViewController(viewController, animated: animated)
//        if self.viewControllers.count > 1 {
//            self.interactivePopGestureRecognizer?.isEnabled = true
//        } else {
//            self.interactivePopGestureRecognizer?.isEnabled = false
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension YWNavigationViewController {
    
    @objc func goBackAction(){
        self.popViewController(animated: true)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)

        if self.viewControllers.count > 1 {
            viewController.navigationItem.hidesBackButton = true
            var target: UIViewController?
            if let ctrl = viewController as? YWBaseViewController {
                target = ctrl } else {target = self}
            let image = UIImage(named: "nav_back")
            let backButton = UIButton(type: .custom)
            backButton.setImage(image, for: .normal)
            backButton.addTarget(target, action: #selector(goBackAction), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
            
            //viewController.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        }
        
    }
}
