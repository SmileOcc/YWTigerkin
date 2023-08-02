//
//  YWAccountHeaderView.swift
//  YWTigerkin
//
//  Created by odd on 7/26/23.
//

import UIKit

class YWAccountHeaderView: UIView {

    var loginBlock:(()->Void)?
    var settingBlock:(()->Void)?
    
    var testIsLogin:Bool = false {
        didSet {
            if testIsLogin == true {
                self.nickNameLabel.text = "一只鱼"
                self.descLabel.text = "荷塘里的一只鱼"
                self.descLabel.isHidden = false
            } else {
                self.nickNameLabel.text = "登录/注册>"
                self.descLabel.text = ""
                self.descLabel.isHidden = true
            }
        }
    }
    
    lazy var headerImgView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.random
        return view
    }()
    
    lazy var stackInfoView: UIStackView = {
        let view = UIStackView(frame: CGRect.zero)
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    lazy var nickNameLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.font = .fscMedium(14)
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.font = .fscRegular(12)
        view.textColor = UIColor.hexColor("0x666666")
        return view
    }()
    
    
    lazy var loginButton: UIButton = {
        let view = Init(UIButton(type: .custom)) {
            $0.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
            $0.eventInterval = 0.5
        }
        return view
    }()
    
    lazy var settingButton: UIButton = {
        let view = Init(UIButton(type: .custom), block: {
            $0.setImage(YWThemesColors.col_themeImage(UIImage(named: "settings")), for: .normal)
            $0.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
            $0.eventInterval = 0.5
        })
        return view
    }()
    
    @objc func loginAction() {
        self.loginBlock?()
    }
    
    @objc func settingAction() {
        self.settingBlock?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(headerImgView)
        self.addSubview(stackInfoView)
        self.addSubview(loginButton)
        self.addSubview(settingButton)
        
        stackInfoView.addArrangedSubview(nickNameLabel)
        stackInfoView.addArrangedSubview(descLabel)
        
        headerImgView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(16)
            make.top.equalTo(self.snp.top).offset(YWConstant.statusBarHeight + 30)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        stackInfoView.snp.makeConstraints { make in
            make.centerY.equalTo(headerImgView.snp.centerY)
            make.left.equalTo(headerImgView.snp.right).offset(6)
        }
        
        loginButton.snp.makeConstraints { make in
            make.left.equalTo(self.headerImgView.snp.left)
            make.top.bottom.equalTo(self.headerImgView)
            make.right.equalTo(self.stackInfoView.snp.right)
        }
        
        settingButton.snp.makeConstraints { make in
            make.right.equalTo(self.snp.right).offset(-16)
            make.top.equalTo(self.snp.top).offset(YWConstant.statusBarHeight + 20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
