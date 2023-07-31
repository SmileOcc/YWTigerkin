//
//  YWSignInView.swift
//  YWTigerkin
//
//  Created by odd on 7/22/23.
//

import UIKit
import RxCocoa
import RxSwift

enum YWSignInType {
    case mobile
    case email
}
class YWSignInView: UIView {

    let disposeBag = DisposeBag()
    
    lazy var passWordField : YWSecureTextField = {
        let field = YWSecureTextField.init(defaultTip: YWLanguageUtility.kLang(key: "input_password"), placeholder: "")
        return field
    }()
    
    var acountField:YWTipsTextField = YWTipsTextField()
    
    var signInBtn : UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.backgroundColor = YWThemesColors.col_themeColor.withAlphaComponent(0.6)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .disabled)
        btn.setTitle(YWLanguageUtility.kLang(key: "sign_in"), for: .normal)
        btn.setTitle(YWLanguageUtility.kLang(key: "sign_in"), for: .disabled)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        return btn
    }()
    
    var fogotPasswordBtn : UIButton = {
       let btn = UIButton()
        btn.setTitle(YWLanguageUtility.kLang(key: "fogot_pwd"), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        btn.setTitleColor(YWThemesColors.col_themeColor, for: .normal)
        btn.sizeToFit()
        return btn
    }()
    
    var errorTipLabel : UILabel = {
        let lab = UILabel.init()
        lab.textColor = YWThemesColors.col_DA70D6
        lab.font = .systemFont(ofSize: 12)
        lab.text = YWLanguageUtility.kLang(key: "email_dolp_wrong_tip")
        lab.isHidden = true
        return lab
    }()
    
    var siginIntype : YWSignInType!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type:YWSignInType) {
        self.init(frame: .zero)
        self.siginIntype = type
        setupUI()
    }
    
    func setupUI()  {
        backgroundColor = UIColor.white
        if self.siginIntype == YWSignInType.mobile {
            acountField = YWPhoneTextField.init(defaultTip: YWLanguageUtility.kLang(key: "mobile_placeholder"), placeholder:"")
        }else {
            acountField = YWTipsTextField.init(defaultTip: YWLanguageUtility.kLang(key: "e_mail_dolphin_placeholder"), placeholder:"")
        }
        

        
        addSubview(acountField)
        addSubview(passWordField)
        addSubview(fogotPasswordBtn)
        addSubview(signInBtn)
        addSubview(errorTipLabel)
        
        ////隐藏输入框（解决ios输入账号和密码时键盘闪烁）
        YWHideTextField.addHideTextField(sourceView: self, textFieldView: passWordField)
        
        acountField.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(56)
            make.top.equalToSuperview()
        }
        
        errorTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(acountField)
            make.top.equalTo(acountField.snp.bottom).offset(2)
            make.height.equalTo(17)
        }
        
        passWordField.snp.makeConstraints { (make) in
            make.size.left.equalTo(acountField)
            make.top.equalTo(acountField.snp.bottom).offset(24)
        }
        
        
        fogotPasswordBtn.snp.makeConstraints { (make) in
            make.right.equalTo(passWordField.snp.right)
            make.top.equalTo(passWordField.snp.bottom).offset(16)
        }
        
        signInBtn.snp.makeConstraints { (make) in
            make.top.equalTo(fogotPasswordBtn.snp.bottom).offset(28)
            make.height.equalTo(48)
            make.left.right.equalTo(passWordField)
        }
        
        acountField.textField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] (_) in
            if self?.siginIntype == .email {
                if self?.acountField.textField.text?.isValidEmail ?? false ||
                    self?.acountField.textField.text?.count == 0 {

                }else{
                    self?.errorTip(hidden: false)
                }
            }else{
                
            }
        }).disposed(by: disposeBag)
        acountField.textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [weak self] (_) in
            self?.errorTip(hidden: true)
        }).disposed(by: disposeBag)
    }
    
    fileprivate func errorTip(hidden:Bool){
        self.errorTipLabel.isHidden = hidden
        self.errorTipLabel.snp.updateConstraints { (make) in
            make.height.equalTo(hidden ? 0 : 17)
        }
        self.passWordField.snp.updateConstraints { (make) in
            make.top.equalTo(acountField.snp.bottom).offset(hidden ? 24 : 40)
        }
    }
    

}

