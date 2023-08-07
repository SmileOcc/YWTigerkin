//
//  YWLanguageAlertView.swift
//  YWTigerkin
//
//  Created by odd on 8/3/23.
//

import UIKit

class YWLanguageAlertView: UIView {

    fileprivate var curLanguage: YWLanguageType = YWUserManager.curLanguage()
    
    init(frame: CGRect, curLanguage: YWLanguageType) {
        super.init(frame: frame)
        self.curLanguage = curLanguage
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var didSelected: (NSInteger)->() = { index in
        
    }
    
    lazy var contentView: UIView = {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: YWConstant.screenWidth, height: 182))
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true

        return view
    }()
    
    func initView() {
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.height.equalTo(182)
            make.bottom.equalTo(self.snp.bottom).offset(-YWConstant.safeBottomHeight)
        }
        
        let h = 182/3
        for i in 0...2 {
            let btn = UIButton(type: .custom)
            btn.backgroundColor = UIColor.white
            if (curLanguage == .CN && i==1) || (curLanguage == .HK && i==0) || (curLanguage == .EN && i==2){
                btn.setTitleColor(YWThemesColors.col_themeColor, for: .normal)
            }else {
                btn.setTitleColor(YWThemesColors.col_333333, for: .normal)
            }
            btn.frame = CGRect(x: 0, y: CGFloat(h)*CGFloat(i)+CGFloat(i), width: self.frame.width, height: CGFloat(h))
            if i == 0 {
                btn.setTitle(YWLanguageUtility.kLang(key: "mine_traditional") , for: .normal)
            }else if i == 1 {
                btn.setTitle(YWLanguageUtility.kLang(key: "mine_simplified")  , for: .normal)
            }else {
                btn.setTitle(YWLanguageUtility.kLang(key: "mine_english") , for: .normal)
            }
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.tag = i + 10
            btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
            contentView.addSubview(btn)
            
            if i != 2 {
                let line = UIView()
                line.backgroundColor = YWThemesColors.col_line
                contentView.addSubview(line)
                line.snp.makeConstraints { (make) in
                    make.left.right.equalTo(self)
                    make.top.equalTo(btn.snp.bottom)
                    make.height.equalTo(1)
                }
            }
        }
    }
    
    @objc func btnAction(btn: UIButton) {
        let index = btn.tag-10
        didSelected(index)
    }


    func showAlert() {
        if let kwindow = YWConstant.kKeyWindow() {
            kwindow.endEditing(true)
            self.alpha = 0
            self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            kwindow.addSubview(self)
            
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1.0
            }
        }
        
    }
}
