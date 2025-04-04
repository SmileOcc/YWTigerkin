//
//  YWNativeWebCommponent.swift
//  YWTigerkin
//
//  Created by 欧冬冬 on 2025/4/4.
//

import UIKit

class YWNativeWebCommponent: YWNavtiveWebBase {

//    override func conforms(to aProtocol: Protocol) -> Bool {
//        if let interactibleProtocol = NSProtocolFromString("WKNativelyInteractible"),
//           aProtocol == interactibleProtocol {
//            return true
//        }
//        return super.conforms(to: aProtocol)
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.random
    }
    
//    override class func conforms(to aProtocol: Protocol) -> Bool {
//        
//
//        let kk = aProtocol
//        if let interactibleProtocol = NSProtocolFromString("WKNativelyInteractible"){
//            interactibleProtocol == kk
//            return true
//        }
//        return super.conforms(to: aProtocol)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
