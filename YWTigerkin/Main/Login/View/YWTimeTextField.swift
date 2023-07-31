//
//  YWTimeTextField.swift
//  YWTigerkin
//
//  Created by odd on 7/23/23.
//

import UIKit

class YWTimeTextField: YWTipsTextField ,UITextFieldDelegate {

    typealias SendTap = ()->()
    
    var sendBtnClick : SendTap?
    
    lazy var sendBtn : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitle(YWLanguageUtility.kLang(key: "send_code"), for: .normal)
        btn.setTitle(YWLanguageUtility.kLang(key: "send_code"), for: .disabled)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        btn.titleLabel?.minimumScaleFactor = 0.3
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
       // btn.addTarget(self, action: #selector(send), for: .touchUpInside)
        return btn
    }()
    
    lazy var countDownLable : UILabel = {
        let labe = UILabel()
        labe.textAlignment = .center
        labe.textColor = UIColor.hexColor("0x999999")
        labe.font = .systemFont(ofSize: 14, weight: .regular)
        labe.backgroundColor = UIColor.white
        return labe
    }()
    
    lazy var timer : Timer = {
        let timer = Timer.init(timeInterval: 1, target: self, selector: #selector(timeDown), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .default)
        return timer
    }()
    
    @objc func timeDown(){
        self.count = self.count - 1
        if self.count > 0{
            if YWUserManager.isENMode() {
                self.countDownLable.text = "\(YWLanguageUtility.kLang(key: "time_down")) \(self.count)s"
            }else {
                self.countDownLable.text = "\(self.count)s\(YWLanguageUtility.kLang(key: "time_down"))"
            }
        }else {
            self.countDownLable.isHidden = true
            self.sendBtn.isHidden = false
            self.sendBtn.setTitle(YWLanguageUtility.kLang(key: "captcha_resend"), for: .normal)
            timer.fireDate = NSDate.distantFuture
       }
    }
    
    var count : Int = 60
    
    
    override func setupUI() {
        super.setupUI()
        textField.keyboardType = .numberPad
        textField.delegate = self
        addSubview(sendBtn)
        addSubview(countDownLable)
        
        sendBtn.snp.makeConstraints { (make) in
            make.width.equalTo(95)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(0)
        }
        
        countDownLable.snp.makeConstraints { (make) in
            make.width.equalTo(147)
            make.top.equalToSuperview().offset(2)
            make.bottom.right.equalToSuperview().offset(-2)
           // make.right.equalTo(0)
        }
        
        clearBtn.snp.updateConstraints { (make) in
            make.width.equalTo(0)
            make.right.equalTo(-95)
        }
        self.countDownLable.isHidden = true
    }
    
    @objc func send() {
        sendBtnClick?()
        startCountDown()
    }
    
    func startCountDown(){
        timer.fireDate = NSDate.init() as Date
        timer.fireDate = Date.distantPast
        self.count = 60
        sendBtn.isHidden = true
        countDownLable.isHidden = false
    }
    
    deinit {
        timer.invalidate()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        timer.invalidate()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = textField.text as NSString?
        let str2 = str?.replacingCharacters(in: range, with: string)
       
            if str2?.count ?? 0 > 6{
                return false
            }
            if string.count > 0 && !(str2?.isValidNumber() ?? false) {
                return false
            }
        return true
    }
    

}
