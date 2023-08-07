//
//  YWShareBottomAlertView.swift
//  YWTigerkin
//
//  Created by odd on 7/22/23.
//

import UIKit

typealias ShareResultCallBlock = (_ platform: YWSharePlatform, _ result: Bool) -> Void

class YWShareBottomAlertView: UIView {

    @objc var shareTitle: String?
    @objc var shareText: String?
    // 短链
    @objc var shareUrl: String?
    // 长链
    @objc var shareLongUrl: String?
    @objc var shareImage: UIImage?
    // 分享类型
    @objc var shareType:YWShareType = .image
    
    //分享按钮点击,如果没有设置,内部自动处理
    var shareClickBlock: ((YWShareItemModel) -> Void)?
    //分享三方平台结果回调
    var shareResultBlock: ShareResultCallBlock?
    //取消事件回调
    var cancelCallBlock: (() -> Void)?
    //分享社区，如果没有设置,内部自动处理
    var shareToUsmartCommunityCallback: (() -> Void)?
    
    //分享按钮集合
    var shareThirdItems:[YWShareItemModel] = []
    //工具分享集合
    var toolsItems:[YWShareItemModel] = []
    
    // 是否显示活动的角标
    var showActivityBoxBadge = false {
        didSet {
            self.thirdBottomView.showActivityBoxBadge = showActivityBoxBadge
            self.toolBottomView.showActivityBoxBadge = showActivityBoxBadge
        }
    }

    //内部默认统一弹出提示
    @objc var isDefaultShowMessage = false
    
    // 一行分享滑动高度
    let kShareLienHeight: CGFloat = 85
    let kShareCancelHeight: CGFloat = 50

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 初始化方法
    func configure(shareType:YWShareType,toolTypes:[YWSharePlatform],thirdTypes:[YWSharePlatform], clickCallBlock:((YWShareItemModel) -> Void)?,resultCallBlock:ShareResultCallBlock?, cancelBlock:(() -> Void)?) {
        
        if toolTypes.count == 0 && thirdTypes.count == 0{
            self.shareThirdItems = YWShareManager.getThirdShareItems(nil,shareType)
            self.toolsItems = YWShareManager.getToolShareItems(nil)
            
        } else {
            self.shareThirdItems = YWShareManager.getThirdShareItems(thirdTypes,shareType)
            self.toolsItems = YWShareManager.getToolShareItems(toolTypes)
        }

        configure(shareType: shareType,
                  toolItems: self.toolsItems,
                  thirdItems: self.shareThirdItems,
                  clickCallBlock: clickCallBlock,
                  resultCallBlock: resultCallBlock,
                  cancelBlock: cancelBlock)
    }
    
    func configure(shareType:YWShareType,toolItems:[YWShareItemModel],thirdItems:[YWShareItemModel], clickCallBlock:((YWShareItemModel) -> Void)?, resultCallBlock:ShareResultCallBlock?, cancelBlock:(() -> Void)?) {
        
        self.shareType = shareType
        self.shareClickBlock = clickCallBlock
        self.cancelCallBlock = cancelBlock
        self.shareResultBlock = resultCallBlock
        
        self.toolsItems = toolItems
        self.shareThirdItems = thirdItems
        
        //优先判断外部传入的
        if thirdItems.count == 0 && toolItems.count == 0{
            self.shareThirdItems = YWShareManager.getThirdShareItems(nil,shareType)
            self.toolsItems = YWShareManager.getToolShareItems(nil)
        }
        
        self.initUI()
    }
    
    // 容器高度
    func currentContentHeight() -> CGFloat {
        var contentH = 11 + 6 + kShareLienHeight + kShareCancelHeight + YWConstant.safeBottomHeight
        if self.shareThirdItems.count >= 3 {
            contentH = 11 + 6 + kShareLienHeight * 2 + kShareCancelHeight + YWConstant.safeBottomHeight
        }
        return contentH
    }
    
    func refreshUI() {
        self.thirdBottomView.refreshBottomView()
        self.toolBottomView.refreshBottomView()
    }
    
    // MARK: - 约束
    func initUI() {
    
        self.addSubview(self.bgContentView)
        self.addSubview(self.thirdBottomView)
        self.addSubview(self.toolBottomView)
        self.addSubview(self.bottomCancelButton)
        self.addSubview(self.lineView)
        
        self.bottomCancelButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(kShareCancelHeight)
            make.bottom.equalToSuperview().offset(-YWConstant.safeBottomHeight)
        }
        
        self.thirdBottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
        self.toolBottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(kShareLienHeight)
            make.top.equalTo(self.thirdBottomView.snp.bottom)
            make.bottom.equalTo(self.bottomCancelButton.snp.top).offset(-11)
        }
        
        self.bgContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.thirdBottomView.snp.top).offset(-6)
            make.bottom.equalToSuperview()
        }
        
        self.lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.bottomCancelButton.snp.top)
            make.height.equalTo(0.5)
        }
        
        //三方分享数据处理
        if self.shareThirdItems.count >= 3 {
            self.thirdBottomView.snp.updateConstraints { make in
                make.height.equalTo(kShareLienHeight)
            }
            self.toolBottomView.shareItems = self.toolsItems
            self.thirdBottomView.shareItems = self.shareThirdItems
        } else {
            self.thirdBottomView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            //隐藏第一行，默认的第三方组，统一显示到第一组去
            let allItemsDatas:[YWShareItemModel] = self.shareThirdItems + self.toolsItems
            self.toolBottomView.shareItems = allItemsDatas
            self.thirdBottomView.shareItems = []
        }
        
    }

    // MARK: - 控件
    lazy var bgContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 16
        return view
    }()
    
    //三方按钮模块
    lazy var thirdBottomView: YXShareBottomContentView = {
        let view = YXShareBottomContentView.init(items: []) {[weak self] itemModel in
            guard let `self` = self else { return }
            if let callBlock = self.shareClickBlock {
                callBlock(itemModel)
            } else {
                self.autoHandleClick(itemModel)
            }
        }
        return view
    }()
    
    //本地工具按钮模块
    lazy var toolBottomView: YXShareBottomContentView = {
        let view = YXShareBottomContentView.init(items: []) {[weak self] itemModel in
            guard let `self` = self else { return }
            if let callBlock = self.shareClickBlock {
                callBlock(itemModel)
            } else {
                self.autoHandleClick(itemModel)
            }
        }
        return view
    }()

    lazy var cancelButton: UIControl = {
        let view = UIControl()
        view.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return view
    }()
    
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor("0xeeeeee")
        return view
    }()
    
    lazy var bottomCancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(YWLanguageUtility.kLang(key: "cancel_btn"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("0x191919"), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        return btn
    }()

    // MARK: - 事件
    // 取消
    @objc func cancelButtonAction() {
        if let cancelBlock = self.cancelCallBlock {
            cancelBlock()
        }
    }
    
    // 事件处理，
    @objc func autoHandleClick(_ itemModel: YWShareItemModel) {
        
        self.shareEvent(itemModel)
    }
    
    // MARK: - 分享事件处理
    func shareEvent(_ itemModel: YWShareItemModel) {
        
        
    }
}


//MARK: - 一行按钮组件

class YXShareBottomContentView: UIScrollView {

    let kShareButtonWidth: CGFloat = 68
    let kShareButtonHeight: CGFloat = 78

    // 是否显示活动的角标
    var showActivityBoxBadge = false
    // 点击事件回调
    var shareSelectCallback: ((YWShareItemModel) -> Void)?

    var shareButtons: [ShareItemView] = [ShareItemView]()
    var shareItems:[YWShareItemModel]? {
        didSet{
            creatShareItme()
            layoutShareView()
        }
    }

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init(items:[YWShareItemModel],clickCallBlack:((YWShareItemModel) -> Void)?) {
        self.init(frame:.zero)
        self.shareItems = items
        self.shareSelectCallback = clickCallBlack
        creatShareItme()
        layoutShareView()
    }

    func initUI() {
        backgroundColor = UIColor.clear
        showsHorizontalScrollIndicator = false

        addSubview(contentView)
        creatShareItme()
        layoutShareView()
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func creatShareItme() {
        shareButtons.forEach { btn in
            btn.removeFromSuperview()
        }
        shareButtons.removeAll()

        if let itmesArray = self.shareItems {
            for subItem in itmesArray {
                shareButtons.append(shareButton(with: (subItem.shareImageName ?? "") as String, title:(subItem.shareName ?? "") as String, tag: subItem.shareTag))
            }
        }
    }

    func layoutShareView() {
        let buttonWidth: CGFloat = kShareButtonWidth
        let count: CGFloat = 4.5 // 一页显示4个半
        let spacing = (YWConstant.screenWidth - buttonWidth * count) / count
        let left = spacing / 2
        let right = spacing / 2
        var lastButton: ShareItemView?
        
        //标题一行显示
        for (i, button) in shareButtons.enumerated() {
            contentView.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.height.equalTo(kShareButtonHeight)
                make.width.equalTo(buttonWidth)

                if let lastBtn = lastButton {
                    make.left.equalTo(lastBtn.snp.right).offset(spacing)
                } else {
                    make.left.equalToSuperview().offset(left)
                }

                if i == shareButtons.count - 1 {
                    make.right.equalToSuperview().offset(-right)
                }
            }
            lastButton = button
            
            button.redView.isHidden = true
            if isshowActivityBoxBadge(tag: button.tag) {
                button.redView.isHidden = false
            }
        }
    }
    
    // 刷新
    func refreshBottomView() {
        for (_, button) in shareButtons.enumerated() {
            let view = button.redView
            if showActivityBoxBadge {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }
    
    func isshowActivityBoxBadge(tag: Int) -> Bool{
        if let itmesArray = self.shareItems {
            for item in itmesArray {
                if item.shareTag ==  tag{
                    if item.sharePlatform == .twitter || item.sharePlatform == .facebook || item.sharePlatform == .instagram {
                        return true
                    }
                }
            }
        }
        return false
    }

    // 分享按钮
    func shareButton(with imageName: String,title :String, tag: Int) -> ShareItemView {
        let shareButton = ShareItemView(frame: CGRect.zero)
        shareButton.imgView.image = UIImage(named: imageName)
        shareButton.titleLab.text = title
        shareButton.tag = tag
        shareButton.tapBlock = {[weak self] currentTag in
            guard let `self` = self else {return}
            self.shareButtonAction(currentTag)
            
        }
        return shareButton
    }

    // MARK: 点击事件
    @objc func shareButtonAction(_ currentTagsender: Int) {
        if currentTagsender > 0, let selectCallBack = self.shareSelectCallback {
            if let itemsArray = self.shareItems {
                
                for subItem in itemsArray {
                    if currentTagsender == subItem.shareTag {
                        selectCallBack(subItem)
                        return
                    }
                }
            }
        }
    }
    
    class ShareItemView: UIView {
        
        var tapBlock:((Int)->Void)?
        
        lazy var redView: UIView = {
            let view = UIView(frame:CGRect.zero)
            view.backgroundColor = UIColor.red
            view.layer.cornerRadius = 2
            view.layer.masksToBounds = true
            view.isHidden = true
            return view
        }()
        
        lazy var imgView: UIImageView = {
            let view = UIImageView(frame: CGRect.zero)
            return view
        }()
        
        lazy var titleLab: UILabel = {
            let view = UILabel(frame: CGRect.zero)
            view.textAlignment = .center
            view.font = UIFont.fscRegular(13)
            view.numberOfLines = 2
            view.textColor = UIColor.hexColor("0x191919")
            return view
        }()
        
        lazy var tapButton: UIButton = {
            let view = UIButton(type: .custom)
            view.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
            view.eventInterval = 1
            return view
        }()
        
        @objc func actionTap() {
            self.tapBlock?(self.tag)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.addSubview(imgView)
            self.addSubview(titleLab)
            self.addSubview(redView)
            self.addSubview(tapButton)
            
            imgView.backgroundColor = UIColor.random
            
            imgView.snp.makeConstraints { make in
                make.top.equalTo(self.snp.top)
                make.centerX.equalTo(self.snp.centerX)
                make.size.equalTo(CGSize.init(width: 30, height: 30))
            }
            
            titleLab.snp.makeConstraints { make in
                make.top.equalTo(self.imgView.snp.bottom).offset(12)
                make.left.right.equalTo(self)
            }
            
            redView.snp.makeConstraints { make in
                make.left.equalTo(self.imgView.snp.right).offset(-2)
                make.bottom.equalTo(self.imgView.snp.top).offset(2)
                make.size.equalTo(CGSize.init(width: 4, height: 4))
            }
            
            tapButton.snp.makeConstraints { make in
                make.edges.equalTo(self)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

