//
//  YWViewModelBased.swift
//  YWTigerkin
//
//  Created by odd on 3/3/23.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa
import URLNavigator

protocol ViewModel {
}

protocol YWServicesViewModel: ViewModel {
    associatedtype Services
    var services: Services! { get set }
    var navigator: YWNavigatorServicesType! { get set }
}

protocol YWViewModelBased: AnyObject {
    associatedtype ViewModelType: ViewModel
    var viewModel: ViewModelType! { get set }
}
extension YWViewModelBased where Self: UIViewController, ViewModelType: YWServicesViewModel {
    static func instantiate<ViewModelType, ServicesType> (withViewModel viewModel: ViewModelType, andServices services: ServicesType, andNavigator navigator: YWNavigatorServicesType) -> Self
        where ViewModelType == Self.ViewModelType, ServicesType == Self.ViewModelType.Services {
            let viewController = Self()
            viewController.viewModel = viewModel
            viewController.viewModel.services = services
            viewController.viewModel.navigator = navigator
            return viewController
    }
}

extension YWViewModelBased where Self: UIViewController & StoryboardBased, ViewModelType: YWServicesViewModel {
    static func instantiate<ViewModelType, ServicesType> (withViewModel viewModel: ViewModelType, andServices services: ServicesType, andNavigator navigator: YWNavigatorServicesType) -> Self
        where ViewModelType == Self.ViewModelType, ServicesType == Self.ViewModelType.Services {
            let viewController = Self.instantiate()
            viewController.viewModel = viewModel
            viewController.viewModel.services = services
            viewController.viewModel.navigator = navigator
            return viewController
    }
}
extension YWViewModelBased where Self: StoryboardBased & UIViewController {
    static func instantiateFromStoryboard<ViewModelType> (withViewModel viewModel: ViewModelType) -> Self
        where ViewModelType == Self.ViewModelType {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}
