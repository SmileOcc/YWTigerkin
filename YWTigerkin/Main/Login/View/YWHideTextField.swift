//
//  YWHideTextField.swift
//  YWTigerkin
//
//  Created by odd on 7/26/23.
//

import UIKit
////隐藏输入框（解决ios输入账号和密码时键盘闪烁）
class YWHideTextField: UITextField {

    //账号和密码连续时相互切换，账号输入键盘闪烁
    @objc class func addHideTextField(sourceView: UIView, textFieldView: UIView) {
        
        let textField = YWHideTextField.init()
        //textField.isHidden = true //不能用隐藏 高度要为1以上
        textField.backgroundColor = UIColor.clear
        textField.isEnabled = false
        
        sourceView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(textFieldView.snp.left)
            make.right.equalTo(textFieldView.snp.right)
            make.height.equalTo(1)
            make.bottom.equalTo(textFieldView.snp.top)
        }
        sourceView.sendSubviewToBack(textField)
    }

}
