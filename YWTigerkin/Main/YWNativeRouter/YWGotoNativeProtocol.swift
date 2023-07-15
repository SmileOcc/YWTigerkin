//
//  YWGotoNativeProtocol.swift
//  YWTigerkin
//
//  Created by odd on 7/11/23.
//

import UIKit

@objc public protocol YWGotoNativeProtocol: AnyObject {

    @objc func gotoNativeViewController(withUrlString urlString : String) -> Bool

}
