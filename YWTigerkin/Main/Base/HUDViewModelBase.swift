//
//  HUDViewModelBase.swift
//  YWTigerkin
//
//  Created by odd on 3/16/23.
//

import Foundation
import RxSwift

enum HUDType {
    case loading(_ msg: String?, _ inWindow: Bool)
    case message(_ msg: String?, _ inWindow: Bool)
    case error(_ msg: String?, _ inWindow: Bool)
    case success(_ msg: String?, _ inWindow: Bool)
    case hide
    
    public var msg: String? {
        switch self {
        case .loading(let msg, _):
            return msg
        case .message(let msg, _):
            return msg
        case .error(let msg, _):
            return msg
        case .success(let msg, _):
            return msg
        default:
            return nil
        }
    }
    
    public var inWindow: Bool {
        switch self {
        case .loading(_, let inWindow):
            return inWindow
        case .message(_ , let inWindow):
            return inWindow
        case .error(_ , let inWindow):
            return inWindow
        case .success(_ , let inWindow):
            return inWindow
        default:
            return false
        }
    }
}


protocol HUDViewModelBased: YWViewModelBased where ViewModelType: HUDServicesViewModel {
    var networkingHUD: YWProgressHUD! {get set}
}

protocol HUDServicesViewModel: YWServicesViewModel {
    var hudSubject: PublishSubject<HUDType>! {get set}
}

extension HUDViewModelBased where Self: UIViewController {

    func bindHUD() {
        
        _ = viewModel.hudSubject?.take(until: self.rx.deallocated).subscribe(onNext: { [weak self] (hudType) in
            guard let strongSelf = self else { return }
            
            let msg = hudType.msg
            let inWindow = hudType.inWindow;
            
            if inWindow == true {
                switch hudType {
                case .loading:
                    strongSelf.networkingHUD.showLoading(msg)
                case .message:
                    strongSelf.networkingHUD.showMessage(msg)
                case .success:
                    strongSelf.networkingHUD.showSuccess(msg)
                case .error:
                    strongSelf.networkingHUD.showError(msg)
                case .hide:
                    strongSelf.networkingHUD.hideHud()
                }
            } else {
                switch hudType {
                case .loading:
                    strongSelf.networkingHUD.showLoading(msg, in: self?.view)
                case .message:
                    strongSelf.networkingHUD.showMessage(msg, in: self?.view)
                case .success:
                    strongSelf.networkingHUD.showSuccess(msg, in: self?.view)
                case .error:
                    strongSelf.networkingHUD.showError(msg, in: self?.view)
                case .hide:
                    strongSelf.networkingHUD.hideHud()
                }
            }
        })
    }
}
