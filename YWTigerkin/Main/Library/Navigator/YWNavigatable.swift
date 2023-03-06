//
//  YWNavigatable.swift
//  YWTigerkin
//
//  Created by odd on 3/3/23.
//

import UIKit
import URLNavigator

class YWNavigatable<T: YWServicesViewModel> {
    var viewModel: T
    var userInfo: [String: Any]?
    required init(viewModel: T, userInfo: [String: Any]? = nil) {
        self.viewModel = viewModel
        self.userInfo = userInfo
    }
}
