//
//  YWQuickLoginView.swift
//  YWTigerkin
//
//  Created by odd on 7/26/23.
//

import UIKit

class YWQuickLoginView: UIView {

    lazy var titLabel : UILabel = {
        let lab = UILabel()
        lab.text = YWLanguageUtility.kLang(key: "quick_login")
        lab.textAlignment = .center
        lab.textColor = YWThemesColors.col_themeColor.withAlphaComponent(0.3)
        lab.font = .systemFont(ofSize: 14, weight: .regular)
        lab.backgroundColor = UIColor.white
        return lab
    }()
    
    lazy var lineView : UIView = {
        let line = UIView.init()
        line.backgroundColor = YWThemesColors.col_line.withAlphaComponent(0.3)
        
        return line
    }()
    
    lazy var faceBookBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icon_signin_fb"), for: .normal)
        return btn
    }()
    
    lazy var googleBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icon_signin_google"), for: .normal)
        return btn
    }()
    
    lazy var weChatBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icon_signin_wechat"), for: .normal)
        return btn
    }()
    
    lazy var appleBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icon_signin_apple"), for: .normal)
        return btn
    }()
    
    lazy var lineBtn : UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage.init(named: "icon_signin_line"), for: .normal)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var showWechat = false
    
    convenience init(hasWeChat:Bool) {
        self.init(frame: .zero)
        self.showWechat = hasWeChat
        setupUI()
    }
    
    func setupUI()  {
        
        var btns:[UIButton] = [faceBookBtn,googleBtn]
       
        addSubview(lineView)
        addSubview(titLabel)
        
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.equalTo(167)
            make.top.equalTo(11.5)
            make.centerX.equalToSuperview()
        }
        
        titLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 95, height: 24))
            make.top.equalToSuperview()
        }
        
        
        weChatBtn.isHidden = !showWechat
        if showWechat {
            btns.append(weChatBtn)
        }
        
        btns.append(lineBtn)
        //ios 13.0及以上支持Apple ID
        if #available(iOS 13.0, *) {
            btns.append(appleBtn)
        }
        
        let itmeCount:CGFloat = CGFloat(btns.count)
        
        let spascing = (UIScreen.main.bounds.size.width - 60 - itmeCount * 40) / (itmeCount - 1)
        var lastBtn = UIView()
        for i in 0..<btns.count {
            let btn = btns[i]
            addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 40, height: 40))
                make.top.equalTo(titLabel.snp.bottom).offset(20)
                if i == 0 {
                    make.left.equalTo(30)
                }else {
                    make.left.equalTo(lastBtn.snp.right).offset(spascing)
                }
            }
            lastBtn = btn
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
