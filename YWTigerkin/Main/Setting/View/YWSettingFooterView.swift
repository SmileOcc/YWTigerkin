//
//  YWSettingFooterView.swift
//  YWTigerkin
//
//  Created by odd on 7/31/23.
//

import UIKit

class YWSettingFooterView: UIView {

    var logoutBlock:(()->Void)?
    
    lazy var logoutButton: UIButton = {
        let view = Init(UIButton(type: .custom)) {
            $0.backgroundColor = YWThemesColors.col_themeColor
            $0.setTitle(YWLanguageUtility.kLang(key: "logout"), for: .normal)
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
            $0.eventInterval = 0.5
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func logoutAction() {
        self.logoutBlock?()
    }
}
