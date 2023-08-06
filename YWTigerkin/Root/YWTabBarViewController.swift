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
    
    // 是否已经展示过了广告页或引导页
    static var adFlag = false
    
    //首页的pop是否check过
    var homePopCheckFlag: Int = 0
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //在这里处理deeplink跳转
        //AppsFlyerService.shared.jumpDeepLink()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light;
        }
   
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.tintColor = UIColor.black
        
        if !YWTabBarViewController.adFlag {
            self.showGuideOrAdvertiseView()
        }
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


//MARK: - 广告 和引导页
extension YWTabBarViewController {
    fileprivate func showGuideOrAdvertiseView() {
        
        //如果不是同一天，则清空用于存储闪屏的数组
        let (sameDay,_) = YWUserManager.isTheSameDay(with: YWUserManager.YWAdvertiseDateCache)
        if sameDay == false {
            let recodeArray = NSMutableArray.init(capacity: 0)
            MMKV.default()?.set(recodeArray, forKey:YWUserManager.YWSplashScreenImageHasReadCodes)
            MMKV.default()?.removeValue(forKey: YWUserManager.YWSplashScreenImage)
            MMKV.default()?.removeValue(forKey: YWUserManager.YWSplashScreenAdvertisement)
            MMKV.default()?.removeValue(forKey: YWUserManager.YWAdvertiseDateCache) //去掉记录的日期，重新判断是否是新的一天
        }
        
        //获取是否是 新版本app
        let isInstall = MMKV.default()?.bool(forKey: "YWIsInstallCacheKey", defaultValue: true) ?? true //默认为true
        //测试数据
        if !isInstall {
            //展示广告页
            self.showAdvertiseView()
        }


        // 设置已经展示过引导页或广告页
        YWTabBarViewController.adFlag = true

        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if let splashScreenImageHasReadCodes:NSMutableArray = MMKV.default()?.object(of: NSMutableArray.self, forKey: YWUserManager.YWSplashScreenImageHasReadCodes) as? NSMutableArray {

                YWUserManager.getSplashscreenAdvertisement(complete: {
                    
                })
                
            } else {
                let recodeArray = NSMutableArray.init(capacity: 0)
                MMKV.default()?.set(recodeArray, forKey:YWUserManager.YWSplashScreenImageHasReadCodes)
                let splashScreenImageHasReadCodes:NSMutableArray? = MMKV.default()?.object(of: NSMutableArray.self, forKey: YWUserManager.YWSplashScreenImageHasReadCodes) as? NSMutableArray
                YWUserManager.getSplashscreenAdvertisement {
                    
                }
            }
        }
    }
    
    //sg显示 闪屏广告 逻辑
    fileprivate func showAdvertiseView() {
        
        var isShowAdviertise = false //是否展示广告，默认false
        
        //一天只展示最多三次
        let (sameDay,_) = YWUserManager.isTheSameDay(with: YWUserManager.YWAdvertiseDateCache)
        if sameDay == false {
          
            //获取闪屏数组
            let advertisData = MMKV.default()?.data(forKey: YWUserManager.YWSplashScreenAdvertisement)
            do {
                let splash = try JSONDecoder().decode(YWSplashScreenList.self, from: advertisData ?? Data())
                let splashItem = splash.dataList?.min { //取出优先级最靠前的广告
                    $0.adPos ?? 0 < $1.adPos ?? 0
                }
                if splashItem == nil {
                    MMKV.default()?.removeValue(forKey: YWUserManager.YWSplashScreenImage)
                    MMKV.default()?.removeValue(forKey: YWUserManager.YWAdvertiseDateCache)
                    MMKV.default()?.removeValue(forKey: YWUserManager.YWSplashScreenAdvertisementShowing)
                    self.homeCheckPopAlertView()
                    return
                } else {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    do {
                        let data = try encoder.encode(splashItem)
                        let mmkv = MMKV.default()
                        mmkv?.set(data, forKey: YWUserManager.YWSplashScreenAdvertisementShowing)
                    } catch {
                        
                    }
                }
                let mmkv = MMKV.default()
                //取出上一次请求中保存下来的优先级最高的一张闪屏，用来展示
                let data = mmkv?.data(forKey:YWUserManager.YWSplashScreenImage)
                YWPopManager.shared.didInstalled()
                
                if let advertiseImg = UIImage(data: data ?? Data()) {
                    //保存展示了闪屏
                     MMKV.default()?.set(true, forKey: YWPopManager.YWAdvertiseDidShowCache)
                    //展示过的闪屏要把id存起来

                    if let splashScreenImageHasReadCodes:NSMutableArray = MMKV.default()?.object(of: NSMutableArray.self, forKey: YWUserManager.YWSplashScreenImageHasReadCodes) as? NSMutableArray {
                        splashScreenImageHasReadCodes.add(String(splashItem?.bannerID ?? 0) as Any)
                        MMKV.default()?.set(splashScreenImageHasReadCodes, forKey:YWUserManager.YWSplashScreenImageHasReadCodes)
                    } else {
                        let recodeArray = NSMutableArray.init(capacity: 1)
                        if !recodeArray.contains(String(splashItem?.bannerID ?? 0)) {
                            recodeArray.add(String(splashItem?.bannerID ?? 0) as Any)
                            MMKV.default()?.set(recodeArray, forKey:YWUserManager.YWSplashScreenImageHasReadCodes)
                        }
                    }
                    
                    
                    isShowAdviertise = true
                    
                    let bgView = YWAdvertiseBaseView(frame: UIScreen.main.bounds, image: advertiseImg)
                    self.view.addSubview(bgView)
                    
                    bgView.callBack = { [weak bgView,self] in
                        bgView?.isHidden = true
                        bgView?.removeFromSuperview()
                        MMKV.default()?.set(false, forKey: YWPopManager.YWAdvertiseDidShowCache)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: YWPopManager.kNotificationName), object: nil, userInfo:nil)
                        bgView = nil
                        self.homeCheckPopAlertView()
                    }
                }
            } catch {
                //YXAdvertiseDidShowCache 闪屏里没有要展示的数据了，表示三张闪屏都已经展示过了
                
            }
        }else {
            MMKV.default()?.set(false, forKey: YWPopManager.YWAdvertiseDidShowCache)
            
              //获取闪屏数组
              let advertisData = MMKV.default()?.data(forKey: YWUserManager.YWSplashScreenAdvertisement)
              do {
                  let splash = try JSONDecoder().decode(YWSplashScreenList.self, from: advertisData ?? Data())
                let splashItem = splash.dataList?.min { //取出优先级最靠前的广告
                    $0.adPos ?? 0 < $1.adPos ?? 0
                  }
                if splashItem == nil {
                    MMKV.default()?.removeValue(forKey: YWUserManager.YWSplashScreenImage)
                    MMKV.default()?.removeValue(forKey: YWUserManager.YWSplashScreenAdvertisementShowing)
                    self.homeCheckPopAlertView()
                    return
                } else {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    do {
                        let data = try encoder.encode(splashItem)
                        let mmkv = MMKV.default()
                        mmkv?.set(data, forKey: YWUserManager.YWSplashScreenAdvertisementShowing)
                    } catch {
                        
                    }
                }
                  let mmkv = MMKV.default()
                  //取出上一次请求中保存下来的优先级最高的一张闪屏，用来展示
                  let data = mmkv?.data(forKey:YWUserManager.YWSplashScreenImage)
                  YWPopManager.shared.didInstalled()
                  
                  if let advertiseImg = UIImage(data: data ?? Data()) {
                    //保存展示了闪屏
                     MMKV.default()?.set(true, forKey: YWPopManager.YWAdvertiseDidShowCache)
                    
                      //展示过的闪屏要把id存起来，是同一天则不删掉
                    if let splashScreenImageHasReadCodes:NSMutableArray = MMKV.default()?.object(of: NSMutableArray.self, forKey: YWUserManager.YWSplashScreenImageHasReadCodes) as? NSMutableArray {
                        splashScreenImageHasReadCodes.add(String(splashItem?.bannerID ?? 0) as Any)
                        MMKV.default()?.set(splashScreenImageHasReadCodes, forKey:YWUserManager.YWSplashScreenImageHasReadCodes)
                    } else {
                        let recodeArray = NSMutableArray.init(capacity: 1)
                        if !recodeArray.contains(String(splashItem?.bannerID ?? 0)) {
                            recodeArray.add(String(splashItem?.bannerID ?? 0) as Any)
                            MMKV.default()?.set(recodeArray, forKey:YWUserManager.YWSplashScreenImageHasReadCodes)
                        }
                    }
                      
                      isShowAdviertise = true
                      
                      let bgView = YWAdvertiseBaseView(frame: UIScreen.main.bounds, image: advertiseImg)
                      self.view.addSubview(bgView)
                      
                      bgView.callBack = { [weak bgView,self] in
                          bgView?.isHidden = true
                          bgView?.removeFromSuperview()
                          MMKV.default()?.set(false, forKey: YWPopManager.YWAdvertiseDidShowCache)
                          NotificationCenter.default.post(name: NSNotification.Name(rawValue: YWPopManager.kNotificationName), object: nil, userInfo:nil)
                          bgView = nil
                          self.homeCheckPopAlertView()
                      }
                  }
              } catch {

              }
        }
        
        if isShowAdviertise ==  false {
            self.homeCheckPopAlertView()
        }
    }
    
    
    /// 请求pop弹窗。需求：闪屏页后，才展示pop弹窗
    func homeCheckPopAlertView() {
        self.homePopCheckFlag += 1
        
        if self.viewControllers?.count ?? 0 > 0, self.homePopCheckFlag >= 2{
            
            let NC = self.viewControllers?[0]
            if let homeNC = NC as? UINavigationController {
                let homeRootVC = homeNC.viewControllers[0]
                if let home = homeRootVC as? YWHomeCtrl {
                    home.checkPopAlertView()
                }
            }
        }
    }
    
}
