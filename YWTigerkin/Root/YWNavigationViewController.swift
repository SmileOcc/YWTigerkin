//
//  YWNavigationViewController.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit

class YWNavigationViewController: UINavigationController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.modalPresentationStyle = .fullScreen
        navigationBar.backIndicatorImage = UIImage.init(named: "nav_back")
        
        self.navigationBar.tintColor = UIColor.green
        self.navigationBar.isTranslucent = false
        
        
//        if #available(iOS 11.0, *) {
//            navigationBar.prefersLargeTitles = true
//        } else {
//            
//        }
        self.view.backgroundColor = UIColor.white
        
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.configureWithOpaqueBackground()
        navBarApperance.backgroundColor = UIColor.orange
        
        UINavigationBar.appearance().standardAppearance = navBarApperance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarApperance
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
