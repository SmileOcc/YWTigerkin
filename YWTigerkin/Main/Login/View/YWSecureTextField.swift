//
//  YWSecureTextField.swift
//  YWTigerkin
//
//  Created by odd on 7/23/23.
//

import UIKit

class YWSecureTextField: YWTipsTextField {
    
    lazy var secureBtn : UIButton = {
        let btn = UIButton.init()
        btn.addTarget(self, action: #selector(secureTap), for: .touchUpInside)
        btn.setImage(YWThemesColors.col_themeImage(UIImage.init(named: "eyes_close")), for: .selected)
        btn.setImage(YWThemesColors.col_themeImage(UIImage.init(named: "eyes_open")), for: .normal)
        btn.isSelected = true
        return btn
    }()
    
    override func setupUI() {
        super.setupUI()
        textField.isSecureTextEntry = true
        textField.keyboardType = .asciiCapable
        addSubview(secureBtn)
        
        secureBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(0)
            make.width.equalTo(50)
        }
      
        
        clearBtn.snp.updateConstraints { (make) in
            make.width.equalTo(16)
            make.right.equalTo(-45)
        }
    }
    
    @objc func secureTap(){
        secureBtn.isSelected = !secureBtn.isSelected
        textField.isSecureTextEntry = secureBtn.isSelected
    }

}
