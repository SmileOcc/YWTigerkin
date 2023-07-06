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
let navColor = UIColor(red: 41/255, green: 160/255, blue: 230/255, alpha: 1)

class YWTabBarViewController: UITabBarController {

    private var navigator: YWNavigatorServicesType?
    
    let disposeBag = DisposeBag()
    
    init(navigator: YWNavigatorServicesType) {
        self.navigator = navigator
//        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black], for: .selected)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 10),NSAttributedString.Key.foregroundColor:UIColor.gray], for: .normal)
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
   
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.tintColor = UIColor.black
    }
    
    func configureRootVCS(navigator: YWNavigatorServicesType, services:AppServices) {
        
        let homeCtrl = YWHomeCtrl.instantiate(withViewModel: YWHomeViewModel(), andServices: services, andNavigator: navigator)
        let homeNav = YWNavigationViewController(rootViewController: homeCtrl)
        homeNav.tabBarItem.title = "首页"
        homeNav.tabBarItem.image = UIImage(named: "tab_home")
        homeNav.tabBarItem.selectedImage = UIImage(named: "tab_home_selected")
        
        let categoryCtrl = YWCategoryCtrl.instantiate(withViewModel: YWCategoryViewModel(), andServices: services, andNavigator: navigator)
        let categoryNav = YWNavigationViewController(rootViewController: categoryCtrl)
        categoryNav.tabBarItem.title = "分类"
        categoryNav.tabBarItem.image = UIImage(named: "tab_categories")
        categoryNav.tabBarItem.selectedImage = UIImage(named: "tab_categories_selected")
        
        let accountCtrl = YWAccountCtrl.instantiate(withViewModel: YWAccountViewModel(), andServices: services, andNavigator: navigator)
        let accountNav = YWNavigationViewController(rootViewController: accountCtrl)
        accountNav.tabBarItem.title = "中心"
        accountNav.tabBarItem.image = UIImage(named: "tab_me")
        accountNav.tabBarItem.selectedImage = UIImage(named: "tab_me_selected")
        
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
