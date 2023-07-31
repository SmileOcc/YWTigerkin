//
//  YWPhoneTextField.swift
//  YWTigerkin
//
//  Created by odd on 7/23/23.
//

import UIKit

class YWPhoneTextField: YWTipsTextField ,UITextFieldDelegate{
    
    typealias AreaClick = (String)->()
    
    var didClickAreaCode : AreaClick?
    
    lazy var areaCodeLale : UILabel = {
        let labl = UILabel()
        labl.text = "+1"
        labl.textAlignment = .left
        labl.textColor = YWThemesColors.col_themeColor
        labl.font = .systemFont(ofSize: 16, weight: .regular)
        return labl
    }()
    
    lazy var logoImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = YWThemesColors.col_themeImage(UIImage.init(named: "icon_more_login"))
        return imageView
    }()
    
    lazy var areaCodeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(self, action: #selector(areaCodeTap), for: .touchUpInside)
        return btn
    }()
    
    override func setupUI() {
        super.setupUI()
        textField.keyboardType = .numberPad
        textField.delegate = self
        addSubview(areaCodeBtn)
        areaCodeBtn.addSubview(areaCodeLale)
        areaCodeBtn.addSubview(logoImageView)
        
        areaCodeLale.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(0)
            make.width.height.equalTo(12)
        }
        
        areaCodeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        textField.snp.updateConstraints { (make) in
            make.left.equalTo(92)
        }
        
        tipsLable.snp.remakeConstraints { (make) in
            make.left.equalTo(92)
            make.top.equalTo(2)
            make.bottom.equalTo(-2)
        }

    }
    
    @objc func areaCodeTap(){
        didClickAreaCode?(areaCodeLale.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = textField.text as NSString?
        let str2 = str?.replacingCharacters(in: range, with: string)
       
            if str2?.count ?? 0 > 11{
                return false
            }
            if string.count > 0 && !(str2?.isValidNumber() ?? false) {
                return false
            }
        return true
    }
    
    override func hiddenTipAnmition() {
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.tipsLable.snp.remakeConstraints { (make) in
                make.left.equalTo(92)
                make.top.equalTo(2)
                make.bottom.equalTo(-2)
            }
            self?.tipsLable.transform  = CGAffineTransform.init(scaleX:1.0,y: 1.0)
            self?.layoutIfNeeded()
        }
        self.hiddenTip()
    }
}
