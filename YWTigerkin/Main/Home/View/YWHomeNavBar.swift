//
//  YWHomeNavBar.swift
//  YWTigerkin
//
//  Created by odd on 8/7/23.
//

import UIKit

class YWHomeNavBar: UIView {

    lazy var rightButton: UIButton = {
        let view = UIButton(type: .custom)
        return view
    }()

    lazy var messageButton: UIButton = {
        let view = UIButton(type: .custom)
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()
    
    var finishedAnimation:Bool = false
    
    var contentViewOffsetY:CGFloat = 0.0
    
    lazy var searchScroll: UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()
    
    lazy var badgeView: UIView = {
        let view = UIView(frame:CGRect.zero)
        return view
    }()
    
    lazy var searchBgView: UIView = {
        let view = UIView(frame:CGRect.zero)
        return view
    }()
    
    lazy var searchIconView: UIView = {
        let view = UIView(frame:CGRect.zero)
        return view
    }()
    
    lazy var inputField: UITextField = {
        let view = UITextField(frame: CGRect.zero)
        return view
    }()
    
    var titleGroupArray:[String] = []
    
    var hotWordsArray:[String] = [] {
        didSet {
            
        }
    }

    deinit {
        print(">>>>>>> \(NSStringFromClass(type(of: self)).split(separator: ".").last!) deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.finishedAnimation = true
        self.isUserInteractionEnabled = true
        self.frame = CGRect(x: 0.0, y: 0.0, width: YWConstant.screenWidth, height: YWConstant.navBarHeight)
        setupView()
        layoutView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBagValues), name: Notification.Name(rawValue:YWConstant.kNotif_CartBadge), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showOrHiddenMessageDot), name: Notification.Name(rawValue:YWConstant.kNotif_ChangeMessageCountDot), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = YWThemesColors.col_whiteColor
        self.backgroundView.backgroundColor = YWThemesColors.col_whiteColor
        self.addSubview(backgroundView)
        self.addSubview(rightButton)
        self.addSubview(messageButton)
        self.addSubview(bottomLine)
        self.addSubview(searchBgView)
        
        searchBgView.addSubview(searchIconView)
        searchBgView.addSubview(searchScroll)
        searchScroll.addSubview(self.inputField)
    }
    
    func layoutView() {
        
    }
    
    @objc func refreshBagValues() {
        
    }
    
    @objc func showOrHiddenMessageDot() {
        
    }
}
