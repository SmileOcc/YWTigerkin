//
//  YWTabBarViewController.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit
import RxSwift
import RxCocoa
import URLNavigator

class YWTabBarViewController: UITabBarController {

    private var navigator: NavigatorServicesType?
    
    let disposeBag = DisposeBag()
    
    init(navigator: NavigatorServicesType) {
        self.navigator = navigator
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.red], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 10),NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
        super.init(nibName: nil, bundle: nil)
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light;
        }
   
    }
    
    func configureRootVCS(navigator: NavigatorProtocol, services:AppServices) {
        
        let homeCtrl = YWHomeCtrl.instantiate(withViewModel: YWHomeViewModel(), andServices: services, andNavigator: navigator)
        let homeNav = YWNavigationViewController(rootViewController: homeCtrl)
//        homNav.tabBarItem.title = "首页"
//        homNav.tabBarItem.image = UIImage(named: "tab_home_selected")
//        homNav.tabBarItem.selectedImage = UIImage(named: "tab_home")
        
        let categoryCtrl = YWCategoryCtrl.instantiate(withViewModel: YWCategoryViewModel(), andServices: services, andNavigator: navigator)
        let categoryNav = YWNavigationViewController(rootViewController: categoryCtrl)
        
        let accountCtrl = YWAccountCtrl.instantiate(withViewModel: YWAccountViewModel(), andServices: services, andNavigator: navigator)
        let accountNav = YWNavigationViewController(rootViewController: accountCtrl)
        
        self.viewControllers = [homeNav,categoryNav,accountNav]
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
