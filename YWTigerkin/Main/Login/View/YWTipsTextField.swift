//
//  YWTipsTextField.swift
//  YWTigerkin
//
//  Created by odd on 7/22/23.
//

import UIKit

enum YWTipsTextFieldSelectStyle {
    case defult
    case none
}

class YWTipsTextField: UIView {

    var selectStyle:YWTipsTextFieldSelectStyle = .defult
    
    //多行内容显示，约束位置、高度调整
    var tipsNumber: Int = 1 {
        didSet {
            self.tipsLable.numberOfLines = tipsNumber
        }
    }
    
    var needAnmitionSelect = true
    lazy var textField : UITextField = {
        let textField = UITextField.init()
        textField.textColor = YWThemesColors.col_333333
        textField.font = .systemFont(ofSize: 16)
        textField.addTarget(self, action: #selector(didChanaged), for: .editingChanged)
        textField.addTarget(self, action: #selector(didBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(didEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(didEndOnExit), for: .editingDidEndOnExit)
        return textField
    }()
    
    lazy var tipsLable : UILabel = {
        let lab = UILabel.init()
        lab.textAlignment = .center
        lab.backgroundColor = UIColor.white
        lab.textColor = YWThemesColors.col_DA70D6
        lab.font = .systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var containerView : UIView = {
        let view = UIView.init()
        view.layer.borderWidth = 1
        view.layer.borderColor = YWThemesColors.col_themeColor.cgColor
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    
    lazy var clearBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(YWThemesColors.col_themeImage(UIImage.init(named: "icon_close_clear")), for: .normal)
        btn.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    
    var defaultTip:String = ""
    
    func attrPlaceholder(_ text:String)->NSMutableAttributedString{
        let attrString = NSMutableAttributedString(string: text)
        attrString.yy_font = UIFont.systemFont(ofSize: 14)
        attrString.yy_color = UIColor.lightGray
        return attrString
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(defaultTip:String,placeholder:String) {
        self.init(frame: .zero)
        self.defaultTip = defaultTip
        self.textField.attributedPlaceholder = attrPlaceholder(placeholder)
        setupUI()
        hiddenTip()
    }
    
   private var isShowed = false
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()  {
        
        self.backgroundColor = UIColor.white
        
        tipsLable.text = defaultTip
        
        self.addSubview(containerView)
        self.addSubview(textField)
        self.addSubview(tipsLable)
        self.addSubview(clearBtn)
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { (make) in
            make.right.equalTo(clearBtn.snp.left)
            make.height.equalToSuperview()
            make.left.equalTo(16)
            make.top.equalToSuperview()
        }
        
        
        tipsLable.snp.remakeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(2)
            make.bottom.equalTo(-2)
        }
        
        clearBtn.snp.makeConstraints { (mark) in
            mark.top.bottom.equalToSuperview()
            mark.width.equalTo(50)
            mark.right.equalTo(0)
        }
        if defaultTip.count <= 0{
            tipsLable.isHidden = true
        }
    }
    
    func showErrorTip(_ tip:String) {
        tipsLable.text = tip
        tipsLable.textColor = YWThemesColors.col_error
        containerView.layer.borderColor = tipsLable.textColor.cgColor
    }
    
    
    func showDefaultTip()  {
        isShowed = true
        let defaultColor = YWThemesColors.col_8A2BE2
    
        if self.selectStyle == .defult {
            containerView.layer.borderColor = defaultColor.cgColor
        }else {
            containerView.layer.borderColor = UIColor.red.cgColor
        }
        tipsLable.textColor = defaultColor
        textField.textColor = defaultColor
        if self.textField.isEnabled == false{
            textField.textColor = UIColor.lightGray
        }
        if defaultTip.count > 0{
            tipsLable.text = defaultTip
            tipsLable.isHidden = false
        }
    }
    
    func hiddenTip()  {
        isShowed = false
        containerView.layer.borderColor = YWThemesColors.col_themeColor.cgColor
        tipsLable.textColor = YWThemesColors.col_themeColor
        if needAnmitionSelect == false {
            tipsLable.isHidden = true
        }
    }
    
    fileprivate func showTipAnmition(){
        guard isShowed == false else {return}
        if needAnmitionSelect == false {
            if self.tipsNumber > 1 {
                self.tipsLable.snp.remakeConstraints { (make) in
                    make.left.equalTo(16)
                    make.top.equalTo(-9 * self.tipsNumber)
                }
            } else {
                self.tipsLable.snp.remakeConstraints { (make) in
                    make.left.equalTo(16)
                    make.top.equalTo(-9)
                }
            }
           
            self.tipsLable.isHidden = false
            self.tipsLable.font = .systemFont(ofSize: 12)
            self.tipsLable.textColor = YWThemesColors.col_themeColor
            self.showDefaultTip()
            return
        }
        let scale = self.tipsLable.frame.size.width * 0.15 * 0.5
        UIView.animate(withDuration: 0.2) { [weak self] in
            
            if let tipNum = self?.tipsNumber, tipNum > 1 {
                self?.tipsLable.snp.remakeConstraints { (make) in
                    make.height.equalTo(18 * tipNum)
                    make.left.equalTo(16-scale)
                    make.top.equalTo(-9 * tipNum)
                }
            } else {
                self?.tipsLable.snp.remakeConstraints { (make) in
                    make.height.equalTo(18)
                    make.left.equalTo(16-scale)
                    make.top.equalTo(-9)
                }
            }
            
            self?.tipsLable.transform  = CGAffineTransform.init(scaleX:0.85,y: 0.85)
            self?.layoutIfNeeded()
        } completion: { [weak self](_) in
            self?.showDefaultTip()
        }
    }
    
    func hiddenTipAnmition(){
        
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.tipsLable.snp.remakeConstraints { (make) in
                make.left.equalTo(10)
                make.top.equalTo(2)
                make.bottom.equalTo(-2)
            }
            self?.tipsLable.transform  = CGAffineTransform.init(scaleX:1.0,y: 1.0)
            self?.layoutIfNeeded()
        }
        self.hiddenTip()
    }
   

}



extension YWTipsTextField{
    
   private func canShowClearBtn() {
        if self.textField.text?.count ?? 0 > 0 {
            clearBtn.isHidden = false
        }else{
            clearBtn.isHidden = true
        }
    }

    
    @objc func clearTextField(){
        self.clearBtn.isHidden = true
        self.textField.text = ""
    }
    
    
    @objc func didChanaged(){
        self.canShowClearBtn()
    }
    
    @objc func didBegin(){
        self.canShowClearBtn()
        showTipAnmition()
    }
    
    @objc func didEnd(){
        self.canShowClearBtn()
        if textField.text?.count ?? 0 <= 0  {
            hiddenTipAnmition()
         }
    }
    
    @objc func didEndOnExit(){
        self.canShowClearBtn()
        if textField.text?.count ?? 0 <= 0  {
             hiddenTipAnmition()
         }
    }
    
    //登录注册邀请码用
    @objc func didBeginOnAnmition(){
        self.canShowClearBtn()
        
        if needAnmitionSelect == false {
            if self.tipsNumber > 1 {
                self.tipsLable.snp.remakeConstraints { (make) in
                    make.left.equalTo(16)
                    make.top.equalTo(-9 * self.tipsNumber)
                }
            } else {
                self.tipsLable.snp.remakeConstraints { (make) in
                    make.left.equalTo(16)
                    make.top.equalTo(-9)
                }
            }
           
            self.tipsLable.isHidden = false
            self.tipsLable.font = .systemFont(ofSize: 12)
            self.tipsLable.textColor = UIColor.random
            self.showDefaultTip()
            return
        }
        let scale = self.tipsLable.frame.size.width * 0.15 * 0.5
        if self.tipsNumber > 1 {
            self.tipsLable.snp.remakeConstraints { (make) in
                make.height.equalTo(18 * self.tipsNumber)
                make.left.equalTo(16-scale)
                make.top.equalTo(-9 * self.tipsNumber)
            }
        } else {
            self.tipsLable.snp.remakeConstraints { (make) in
                make.height.equalTo(18)
                make.left.equalTo(16-scale)
                make.top.equalTo(-9)
            }
        }
        
        self.tipsLable.transform  = CGAffineTransform.init(scaleX:0.85,y: 0.85)
        self.layoutIfNeeded()
        self.showDefaultTip()
        
    }
    
    @objc func didEndNoAnmition(){
        self.canShowClearBtn()
        if textField.text?.count ?? 0 <= 0  {
            
            self.tipsLable.snp.remakeConstraints { (make) in
                make.left.equalTo(10)
                make.top.equalTo(2)
                make.bottom.equalTo(-2)
            }
            self.tipsLable.transform  = CGAffineTransform.init(scaleX:1.0,y: 1.0)
            self.layoutIfNeeded()
            self.hiddenTip()
         }
    }
    
}
