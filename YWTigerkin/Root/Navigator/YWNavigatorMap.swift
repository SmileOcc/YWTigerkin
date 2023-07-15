//
//  YWNavigatorMap.swift
//  YWTigerkin
//
//  Created by odd on 3/3/23.
//

import Foundation
import URLNavigator
//import SwiftyJSON
import UIKit

let YW_SCHEME = "ywtigerkin://"

public struct YWNavigationMap {

    static var navigator :YWNavigatorServicesType!
    
    static func initialize(navigator: YWNavigatorServicesType, services:AppServices) {
        
        self.navigator = navigator
        
        
        // 代码搜索
        navigator.register(YWModulePaths.search.url) { (url, values, context) -> UIViewController? in
            
//            let dic = context as? [String : Any]
//            let types: [YXSearchType] = dic?["types"] as? [YXSearchType] ?? []
//            let param: YXSearchParam? = dic?["param"] as? YXSearchParam
//            let secuGroup: YXSecuGroup? = dic?["secuGroup"] as? YXSecuGroup
//            let showPopular: Bool = dic?["showPopular"] as? Bool ?? true
//            let showLike: Bool = dic?["showLike"] as? Bool ?? true
//            let showHistory: Bool = dic?["showHistory"] as? Bool ?? true
//
//            let searchViewModel = YXNewSearchViewModel()
//            searchViewModel.types = types
//            searchViewModel.secuGroup = secuGroup
//            searchViewModel.defaultParam = param
//            searchViewModel.showPopular = showPopular
//            searchViewModel.showHistory = showHistory

            let searchViewModel = YWSearchViewModel()
            let viewController = YWSearchCtrl.instantiate(withViewModel: searchViewModel, andServices: services, andNavigator: navigator as! YWNavigatorServices)
//            let navController = YWNavigationViewController(rootViewController: viewController)
//            navController.modalPresentationStyle = .fullScreen
//            if #available(iOS 11.0, *) {
//                navController.navigationBar.prefersLargeTitles = false
//            }

            return viewController
        }
        
        // 视频
        navigator.register(YWModulePaths.video.url) { (url, values, context) -> UIViewController? in
            
            if let navigatable = context as? YWNavigatable<YWVideoViewModel> {
                let vc = YWVideoCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }

            return nil
        }
        
        // 其他
        navigator.register(YWModulePaths.settingOther.url) { (url, values, context) -> UIViewController? in
            
            if let navigatable = context as? YWNavigatable<YWOtherTestViewModel> {
                let vc = YWOhterTestCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }

            return nil
        }
        
        // 支付
        navigator.register(YWModulePaths.payCenter.url) { (url, values, context) -> UIViewController? in
            
            if let navigatable = context as? YWNavigatable<YWApplePayViewModel> {
                let vc = YWApplePayCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }

            return nil
        }
        
        // 支付
        navigator.register(YWModulePaths.douYinVidoe.url) { (url, values, context) -> UIViewController? in
            
            if let navigatable = context as? YWNavigatable<YWDouYinVideoViewModel> {
                let vc = YWDouYinVideoCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }

            return nil
        }
        
        // 网页
        navigator.register(YWModulePaths.webPage.url) { (url, values, context) -> UIViewController? in
            
            if let navigatable = context as? YWNavigatable<YWWebViewModel> {
                let vc = YWWebCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }

            return nil
        }

        
        
//        // 用户中心-设置
//        navigator.register(HCModulePaths.userCenterSet.url) { (url, values, context) -> UIViewController? in
//            let searchViewModel = HCSearchViewModel()
//            let viewController = HCSearchViewController.instantiate(withViewModel: searchViewModel, andServices: services, andNavigator: navigator)
//            let navController = HCNavigationViewController(rootViewController: viewController)
//            navController.modalPresentationStyle = .fullScreen
//            if #available(iOS 11.0, *) {
//                navController.navigationBar.prefersLargeTitles = false
//            }
//            return navController
//        }
//        
//        navigator.register(HCModulePaths.userCenterUserAccount.url) { (url, values, context) -> UIViewController? in
//            let searchViewModel = HCSearchViewModel()
//            let viewController = HCSearchViewController.instantiate(withViewModel: searchViewModel, andServices: services, andNavigator: navigator)
//            let navController = HCNavigationViewController(rootViewController: viewController)
//            navController.modalPresentationStyle = .fullScreen
//            if #available(iOS 11.0, *) {
//                navController.navigationBar.prefersLargeTitles = false
//            }
//            return navController
//        }
//        
//        navigator.register(HCModulePaths.market.url) { (url, values, context) -> UIViewController? in
//            let searchViewModel = HCMarketViewModel()
//            let viewController = HCMarketViewController.instantiate(withViewModel: searchViewModel, andServices: services, andNavigator: navigator)
//            return viewController
//        }
//        
//        
//        // 网页浏览
////        navigator.register(HCModulePaths.webView.url) { (url, values, context) -> UIViewController? in
////            if let viewModel = context as? YXWebViewModel {
////                let vc = YXWebViewController.instantiate(withViewModel: viewModel, andServices: services, andNavigator: navigator)
////                return vc
////            }
////            return nil
////        }
//        
//        
//        
//        
//        
//        // 用户中心-我的收藏
//        navigator.register(HCModulePaths.userCenterCollect.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? HCNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
//        
//        // 注册Code
//        navigator.register(HCModulePaths.registerCode.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? HCNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
//        
//        // 普通注册界面Code
//        navigator.register(HCModulePaths.normalRegisterCode.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? HCNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
//        
//        // 普通注册设置密码
//        navigator.register(HCModulePaths.normalRegisterSetPwd.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? HCNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
//        
//        // 用户中心
//        navigator.register(HCModulePaths.userCenter.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? HCNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
//        
//        // 用户中心-关于
//        navigator.register(HCModulePaths.userCenterAbout.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? HCNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
        
        
    }
}
