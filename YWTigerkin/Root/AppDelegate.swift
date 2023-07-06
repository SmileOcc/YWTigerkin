//
//  AppDelegate.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit

///< MARK: print
func YWLog<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}

let YWAppDelegate = UIApplication.shared.delegate as? AppDelegate


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var screen_set:SCREEN_SET = .set_port

    var window: UIWindow?
    var tab: YWTabBarViewController?

    lazy var appServices = {
        AppServices(loginService: YWLoginService(),
                    userService: YWUserService(),
                    searchService: YWSearchService(),commonService: YWCommonService())
    }()
    
    public let navigator = YWNavigatorServices.shareInstance

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //判断是否第一次安装
        let isFirstInstall = false
        
        YWFullScreenPop.configure()
        
        YWNavigationMap.initialize(navigator: navigator, services: appServices)

        self.yw_Application(application, didFinishLaunchingWithOptions: launchOptions)
        
        YWLog("开始----")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        initRootViewController()
        
        //1.获取网络权限 根据权限进行人机交互
        if __IPHONE_10_0 != 0 && isFirstInstall {
            self.networkApp(application, didFinishLaunchingWithOptions: launchOptions)
        } else {
            //2.2已经开启网络权限 监听网络状态 可以不处理
        }
        return true
    }

    func initRootViewController() {
        
        self.tab = YWTabBarViewController(navigator: navigator)
        self.tab?.configureRootVCS(navigator: navigator, services: appServices)
        self.window?.rootViewController = self.tab!
        self.window?.makeKeyAndVisible()
    }

    // 16.0需要判断第一次安装网络判断 选择后发送通知刷新首页
    func networkApp(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        // 有网络变化，会触发下面回调
//        let cellularData = CTCellularData()
//
//        cellularData.cellularDataRestrictionDidUpdateNotifier = { state in
//            if state == .notRestricted {
//                // 有网络发送 首页刷新、检查app更新通知等 需要延时0.5s,不及时
//                bk_delay(by: 0.5) {
//                    checkNetStatus(application, didFinishLaunchingWithOptions: launchOptions)
//                }
//            } else  {
//            }
//        }
        
    }
    
    //可以判断网络等
    func checkNetStatus(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        //发送通知
        //检查更新
    }
    
    ///判断网络是否有权限
//    private func isNetworkPermissions() -> Bool {
//        var isNetworkPermissions:Bool = false
//        let cellularData = CTCellularData()
//        ///线程信号量
//        let semaphore = DispatchSemaphore(value: 0)
//
//        cellularData.cellularDataRestrictionDidUpdateNotifier = { state in
//            if state == .notRestricted {
//                isNetworkPermissions = true
//                // 有网络发送 首页刷新、检查app更新通知等 需要延时0.5s,不及时
//            } else  {
//                isNetworkPermissions = false
//            }
//
//            semaphore.signal()
//        }
//
//        semaphore.wait()
//        return isNetworkPermissions
//    }


}


struct AppServices: HasYWLoginService, HasYWUserService, HasYWSearchService,HasYWCommonService {
    let loginService: YWLoginService
    let userService: YWUserService
    let searchService: YWSearchService
    let commonService: YWCommonService
}
