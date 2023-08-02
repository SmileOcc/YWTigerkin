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
let navColor = YWThemesColors.col_themeColor //UIColor(red: 41/255, green: 160/255, blue: 230/255, alpha: 1)

@objc public enum YWTabIndex: Int {
    case home           = 0         // 首页
    case category       = 1         // 分类
    case news           = 2         // 新闻
    case mine           = 3         // 我的
    
    var title: String {
        switch self {
        case .home:
            return YWLanguageUtility.kLang(key: "tab_home")
        case .category:
            return YWLanguageUtility.kLang(key: "tab_category")
        case .news:
            return YWLanguageUtility.kLang(key: "tab_news")
        case .mine:
            return YWLanguageUtility.kLang(key: "tab_mine")
        }
    }
    
    var img: String {
        switch self {
        case .home:
            return "tab_home"
        case .category:
            return "tab_categories"
        case .news:
            return "tab_new"
        case .mine:
            return "tab_me"
        }
    }
    
    var selectImg: String {
        switch self {
        case .home:
            return "tab_home_selected"
        case .category:
            return "tab_categories_selected"
        case .news:
            return "tab_new_select"
        case .mine:
            return "tab_me_selected"
        }
    }
}

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
    
    func configureNave(_ nav:YWNavigationViewController, _ index: YWTabIndex) {
        nav.tabBarItem.title = index.title
        nav.tabBarItem.image = UIImage(named: index.img)
        nav.tabBarItem.selectedImage = UIImage(named: index.selectImg)
    }
    
    func configureRootVCS(navigator: YWNavigatorServicesType, services:AppServices) {
        
        let homeCtrl = YWHomeCtrl.instantiate(withViewModel: YWHomeViewModel(), andServices: services, andNavigator: navigator)
        let homeNav = YWNavigationViewController(rootViewController: homeCtrl)
        self.configureNave(homeNav, YWTabIndex.home)
        
        let categoryCtrl = YWCategoryCtrl.instantiate(withViewModel: YWCategoryViewModel(), andServices: services, andNavigator: navigator)
        let categoryNav = YWNavigationViewController(rootViewController: categoryCtrl)
        self.configureNave(categoryNav, YWTabIndex.category)

        
        let newsCtrl = YWNewsCtrl.instantiate(withViewModel: YWNewsViewModel(), andServices: services, andNavigator: navigator)
        let newsNav = YWNavigationViewController(rootViewController: newsCtrl)
        self.configureNave(newsNav, YWTabIndex.news)

        let accountCtrl = YWAccountCtrl.instantiate(withViewModel: YWAccountViewModel(), andServices: services, andNavigator: navigator)
        let accountNav = YWNavigationViewController(rootViewController: accountCtrl)
        self.configureNave(accountNav, YWTabIndex.mine)

        
        self.viewControllers = [homeNav,categoryNav,newsNav,accountNav]
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
