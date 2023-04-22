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
                    searchService: YWSearchService())
    }()
    
    public let navigator = YWNavigatorServices.shareInstance

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        YWFullScreenPop.configure()
        
        YWNavigationMap.initialize(navigator: navigator, services: appServices)

        YWLog("开始----")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        initRootViewController()
        return true
    }

    func initRootViewController() {
        
        self.tab = YWTabBarViewController(navigator: navigator)
        self.tab?.configureRootVCS(navigator: navigator, services: appServices)
        self.window?.rootViewController = self.tab!
        self.window?.makeKeyAndVisible()
    }


}


struct AppServices: HasYWLoginService, HasYWUserService, HasYWSearchService {
    let loginService: YWLoginService
    let userService: YWUserService
    let searchService: YWSearchService
}
