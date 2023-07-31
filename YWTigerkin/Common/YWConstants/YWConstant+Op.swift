//
//  YWConstant+Op.swift
//  YWTigerkin
//
//  Created by odd on 7/26/23.
//

import Foundation
import UIKit

internal func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
    block(value)
    return value
}


class YWConstModel:NSObject {
    var naem:String?
    var id:String?
}
precedencegroup ConstOp {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator >>>-: ConstOp

func >>>- <T: UIView>(left: (T, T), block: (inout YWConstModel) -> Void){
    var info = YWConstModel()
    //left.0 left.1
    block(&info)
}

@discardableResult
func >>>- <T: UIView>(left: T, block: (inout YWConstModel) -> Void) -> UIView{
    var info = YWConstModel()
    block(&info)
    return UIView()
}
