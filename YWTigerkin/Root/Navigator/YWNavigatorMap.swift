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
        
        // 登录
        navigator.register(YWModulePaths.login.url) { (url, values, context) -> UIViewController? in
            
            if let navigatable = context as? YWNavigatable<YWLoginViewModel> {
                let vc = YWLoginCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }

            return nil
        }
        //MARK: - 我的
        // 用户中心
        navigator.register(YWModulePaths.userCenter.url) { (url, values, context) -> UIViewController? in
            if let navigatable = context as? YWNavigatable<YWAccountCenterViewModel> {
                let vc = YWAccountCenterCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }
            return nil
        }
        
        //MARK: -搜索
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
            let viewController = YWSearchCtrl.instantiate(withViewModel: searchViewModel, andServices: services, andNavigator: navigator )
//            let navController = YWNavigationViewController(rootViewController: viewController)
//            navController.modalPresentationStyle = .fullScreen
//            if #available(iOS 11.0, *) {
//                navController.navigationBar.prefersLargeTitles = false
//            }

            return viewController
        }
        
        navigator.register(YWModulePaths.searchResut.url) { (url, values, context) -> UIViewController? in
            
            if let navigatable = context as? YWNavigatable<YWSearchResultViewModel> {
                let vc = YWSearchResultCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }

            return nil
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
        
        // 抖音
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

        
        
        // 用户中心-设置
        navigator.register(YWModulePaths.userCenterSet.url) { (url, values, context) -> UIViewController? in
            if let navigatable = context as? YWNavigatable<YWSettingViewModel> {
                let vc = YWSettingCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }
            return nil
        }
        
        //MARK: - 消息
        navigator.register(YWModulePaths.messageCenter.url) { (url, values, context) -> UIViewController? in
            if let navigatable = context as? YWNavigatable<YWMessageViewModel> {
                let vc = YWMessageCenterCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }
            return nil
        }
        
        //MARK: - 购物车
        navigator.register(YWModulePaths.cart.url) { (url, values, context) -> UIViewController? in
            if let navigatable = context as? YWNavigatable<YWCartViewModel> {
                let vc = YWCartCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }
            return nil
        }
        
        //MARK: - 订单
        navigator.register(YWModulePaths.orderCenter.url) { (url, values, context) -> UIViewController? in
            if let navigatable = context as? YWNavigatable<YWOrderViewModel> {
                let vc = YWOrderCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }
            return nil
        }
        
        navigator.register(YWModulePaths.orderList.url) { (url, values, context) -> UIViewController? in
            if let navigatable = context as? YWNavigatable<YWOrderItemListViewModel> {
                let vc = YWOrderListCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }
            return nil
        }
        
        navigator.register(YWModulePaths.orderDetail.url) { (url, values, context) -> UIViewController? in
            if let navigatable = context as? YWNavigatable<YWOrderDetailViewModel> {
                let vc = YWOrderDetailCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }
            return nil
        }
        
        
        //MARK: - 活动中心
        navigator.register(YWModulePaths.activityCenter.url) { (url, values, context) -> UIViewController? in
            if let navigatable = context as? YWNavigatable<YWActivityCenterViewModel> {
                let vc = YWActivityCenterCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }
            return nil
        }
        
        //MARK: - 地址
        navigator.register(YWModulePaths.addressCenter.url) { (url, values, context) -> UIViewController? in
            if let navigatable = context as? YWNavigatable<YWAddressListViewModel> {
                let vc = YWAddressListCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }
            return nil
        }
        
        navigator.register(YWModulePaths.addressEdit.url) { (url, values, context) -> UIViewController? in
            if let navigatable = context as? YWNavigatable<YWAddressEditViewModel> {
                let vc = YWAddressEditCtrl.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
                return vc
            }
            return nil
        }
//        
//        navigator.register(YWModulePaths.userCenterUserAccount.url) { (url, values, context) -> UIViewController? in
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
//        navigator.register(YWModulePaths.market.url) { (url, values, context) -> UIViewController? in
//            let searchViewModel = HCMarketViewModel()
//            let viewController = HCMarketViewController.instantiate(withViewModel: searchViewModel, andServices: services, andNavigator: navigator)
//            return viewController
//        }
//        
//        
//        // 网页浏览
////        navigator.register(YWModulePaths.webView.url) { (url, values, context) -> UIViewController? in
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
//        navigator.register(YWModulePaths.userCenterCollect.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? YWNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
//        
//        // 注册Code
//        navigator.register(YWModulePaths.registerCode.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? YWNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
//        
//        // 普通注册界面Code
//        navigator.register(YWModulePaths.normalRegisterCode.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? YWNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
//        
//        // 普通注册设置密码
//        navigator.register(YWModulePaths.normalRegisterSetPwd.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? YWNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
//        
//        // 用户中心
//        navigator.register(YWModulePaths.userCenter.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? YWNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
//        
//        // 用户中心-关于
//        navigator.register(YWModulePaths.userCenterAbout.url) { (url, values, context) -> UIViewController? in
//            if let navigatable = context as? YWNavigatable<HCLoginViewModel> {
//                let vc = HCLoginViewController.instantiate(withViewModel: navigatable.viewModel, andServices: services, andNavigator: navigator)
//                return vc
//            }
//            return nil
//        }
        
        
    }
}
