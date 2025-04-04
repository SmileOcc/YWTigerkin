//
//  YWHomeNavBar.swift
//  YWTigerkin
//
//  Created by odd on 8/7/23.
//

import UIKit


enum HomeNavBarType:Int {
    case unknown = 0
    case search = 1
    case cart = 2
    case message = 3
    case collect = 4
}

class YWHomeNavBar: YYAnimatedImageView {
    
    var clickBlock:((HomeNavBarType,String)->Void)?

    lazy var rightButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "bag_new"), for: .normal)
        view.addTarget(self, action: #selector(clickButtonAction(sender:)), for: .touchUpInside)
        view.imageView?.contentMode = .center
        view.tag = HomeNavBarType.cart.rawValue
        view.setClickEdge(10)
        return view
    }()

    lazy var messageButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "nav_message"), for: .normal)
        view.addTarget(self, action: #selector(clickButtonAction(sender:)), for: .touchUpInside)
        view.imageView?.contentMode = .center
        view.tag = HomeNavBarType.message.rawValue
        view.setClickEdge(10)
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = YWThemesColors.col_CCCCCC
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
    
    lazy var badgeeView: UIView = {
        let view = UIView(frame:CGRect.zero)
        return view
    }()
    
    lazy var searchBgView: UIView = {
        let view = UIView(frame:CGRect.zero)
        view.backgroundColor = YWThemesColors.col_themeColor_03
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    lazy var searchIconView: UIImageView = {
        let view = UIImageView(frame:CGRect.zero)
        view.image = UIImage(named: "search_gray")
        return view
    }()
    
    lazy var inputField: UITextField = {
        let view = UITextField(frame: CGRect.zero)
        view.backgroundColor = YWThemesColors.col_F5F5F5
        view.font = .fscRegular(14)
        view.textColor = YWThemesColors.col_999999
        view.isHidden = true
        
        let placeHolderColor = YWThemesColors.col_B2B2B2
        let attrStr = NSAttributedString(string: YWLanguageTool("search"),attributes: [NSAttributedString.Key.foregroundColor: YWThemesColors.col_0D0D0D, NSAttributedString.Key.font: UIFont.fscRegular(14)])
        view.attributedPlaceholder = attrStr
        view.isUserInteractionEnabled = false
        view.textAlignment = .left
        
        if YWLocalConfigManager.isRightToLeftShow() {
            view.textAlignment = .right
        }
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
        self.backgroundView.backgroundColor = YWThemesColors.col_themeColor
        self.addSubview(backgroundView)
        self.addSubview(rightButton)
        self.addSubview(messageButton)
        self.addSubview(bottomLine)
        self.addSubview(searchBgView)
        
        searchBgView.addSubview(searchIconView)
        searchBgView.addSubview(searchScroll)
        searchScroll.addSubview(self.inputField)
        
        self.showCartCount()
        self.showOrHiddenMessageDot()
    }
    
    func layoutView() {
        let top = YWConstant.statusBarHeight
        
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        self.rightButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-14)
            make.width.height.equalTo(24)
            make.top.equalTo(top)
        }
        
        self.messageButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalTo(self.rightButton.snp.leading).offset(-16)
            make.top.equalTo(top)
        }
        
        self.searchBgView.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.height.equalTo(32)
            make.trailing.equalTo(self.messageButton.snp.leading).offset(-16)
            make.centerY.equalTo(self.messageButton.snp.centerY)
        }
        
        self.searchIconView.snp.makeConstraints { make in
            make.leading.equalTo(self.searchBgView.snp.leading).offset(14)
            make.centerY.equalTo(self.searchBgView.snp.centerY)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        
        self.searchScroll.snp.makeConstraints { make in
            make.leading.equalTo(self.searchIconView.snp.trailing).offset(5)
            make.top.bottom.equalTo(self.searchBgView)
            make.trailing.equalTo(self.searchBgView.snp.trailing)
        }
        
        self.inputField.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.searchScroll)
        }
    }
    
    func setBarBackgroundImage(_ image: UIImage) {
        self.backgroundView.backgroundColor = UIColor.clear
        self.showBottomLine(false)
        self.image = image
        
    }
    
    func showBottomLine(_ show: Bool) {
        self.bottomLine.isHidden = !show
    }
    
    
    @objc func clickButtonAction(sender: UIButton) {
        self.clickBlock?(HomeNavBarType.init(rawValue: sender.tag) ?? .unknown, "")
    }
    
    @objc func refreshBagValues() {
        self.showCartCount()
    }
    
    @objc func showCartCount() {
        
    }
    @objc func showOrHiddenMessageDot() {
        
    }
}
