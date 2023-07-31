//
//  YWShareImageContentView.swift
//  YWTigerkin
//
//  Created by odd on 7/22/23.
//

import UIKit

class YWShareImageContentView: UIView {

    var shareBlock: ((YWShareItemModel) -> Void)?
    var cancelBlock: (() -> Void)?
    
    @objc var shareType:YWShareType = .image
    //内部默认统一弹出提示
    @objc var isDefaultShowMessage = true {
        didSet {
            self.bottomView.isDefaultShowMessage = isDefaultShowMessage
        }
    }
    let kImageViewTopMargin: CGFloat = 44 + (YWConstant.deviceScaleEqualToXStyle() ? 20.0 : 0.0)
    func bottomContentHeight() -> CGFloat {
        return self.bottomView.currentContentHeight()
    }
    
    deinit {
        print("deinit YXShareImageContentView")
    }
    var shareImage: UIImage? {
        didSet {
            self.imageView.image = shareImage
            self.bottomView.shareImage = shareImage
            if self.imageView.superview != nil {
                let bottomContentH = bottomContentHeight()
                
                //底部分享视图
                let imageViewBottomMargin: CGFloat = 24 * self.scale
                let maxImageHeight = YWConstant.screenHeight - self.kImageViewTopMargin - imageViewBottomMargin - bottomContentH
                var imageWidth: CGFloat = self.imageViewWidth
                var imageHeight: CGFloat = self.imageViewHeight
                if let tempImageWidth = shareImage?.cgImage?.width, let tempImageHeight = shareImage?.cgImage?.height, let imageScale = shareImage?.scale {
                    //优先根据宽度布局
                    let originWidth = CGFloat(tempImageWidth) / imageScale
                    let originHeight = CGFloat(tempImageHeight) / imageScale
                    let height = imageWidth * originHeight / originWidth
                    if height > maxImageHeight {
                        imageHeight = maxImageHeight
                        //重新计算宽度
                        imageWidth = originWidth * imageHeight / originHeight
                    } else {
                        imageHeight = height
                    }
                }

                self.imageView.snp.updateConstraints { (make) in
                    make.width.equalTo(imageWidth)
                    make.height.equalTo(imageHeight)
                }


            }
        }
    }

    var contentView: UIView?
    var scale = YWConstant.screenWidth / 375.0
    var imageViewWidth: CGFloat = YWConstant.screenWidth * 0.85
    var imageViewHeight: CGFloat = 0

    func convertToImage() {

        self.contentView?.setNeedsDisplay()
        self.contentView?.layoutIfNeeded()
        if let shareView = self.contentView, let image = shareView.xz_snapshotImage {
            self.shareImage = image
        }
    }

    //MARK: Show Or Hide
    @objc func showShareView() {

        let window = YWConstant.kKeyWindow()
        
        
        window.addSubview(self)
        
        showShareBottomView()

    }

    @objc func hideShareView() {
        self.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { finish in
            self.removeFromSuperview()
        }
    }
    
    @objc func showShareBottomView(){
       
        blurview.isHidden = true
    }

    var blurview : UIVisualEffectView!
    //MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect,shareType: YWShareType, toolTypes:[YWSharePlatform],thirdTypes:[YWSharePlatform], clickCallBlock:((YWShareItemModel) -> Void)?, cancelCallBlock:(() -> Void)?) {
        
        self.init(frame: frame)

        self.shareType = shareType
        self.shareBlock = clickCallBlock
        self.cancelBlock = cancelCallBlock
        
        self.bottomView.configure(shareType: shareType, toolTypes: toolTypes, thirdTypes: thirdTypes, clickCallBlock: { [weak self] itemModel in
            
            guard let `self` = self else { return }

            //这个要在触发事件的 处理了，FB分享调用中，视图移除，就会失败
            //self.hideShareView()
            
//            if YWShareManager.isNeedHiddeModalPresent(itemModel.sharePlatform) {
//                if let callBlock = self.shareBlock {
//                    callBlock(itemModel)
//                    return
//                }
//            }
            
            self.shareBlock?(itemModel)
            self.hideShareView()
            
        }, resultCallBlock: {(platform, result) in
            
        }, cancelBlock: {[weak self] in
            
            guard let `self` = self else { return }
            if let cancelBlock = self.cancelBlock {
                cancelBlock()
            }
            self.hideShareView()
        })

        self.bottomView.snp.updateConstraints { make in
            make.height.equalTo(self.bottomContentHeight())
        }

    }
    
    @objc convenience init(frame: CGRect,shareType: YWShareType, items:[YWShareItemModel],thirdItems:[YWShareItemModel], clickCallBlock:((YWShareItemModel) -> Void)?, cancelCallBlock:(() -> Void)?) {
        
        self.init(frame: frame)

        self.shareType = shareType
        self.shareBlock = clickCallBlock
        self.cancelBlock = cancelCallBlock
        
        self.bottomView.configure(shareType: shareType, toolItems: items, thirdItems: thirdItems, clickCallBlock: { [weak self] itemModel in
            
            guard let `self` = self else { return }

            //这个要在触发事件的 处理了，FB链接分享调用中，视图移除，就会失败
            //self.hideShareView()
            
//            if YWShareManager.isNeedHiddeModalPresent(itemModel.sharePlatform) {
//                self.shareBlock?(itemModel)
//                return
//            }
            
            self.shareBlock?(itemModel)
            self.hideShareView()
            
        }, resultCallBlock: {(platform, result) in
            
        }, cancelBlock: {[weak self] in
            
            guard let `self` = self else { return }
            if let cancelBlock = self.cancelBlock {
                cancelBlock()
            }
            self.hideShareView()
        })

        self.bottomView.snp.updateConstraints { make in
            make.height.equalTo(self.bottomContentHeight())
        }

    }

    func initUI() {
        
        self.frame = UIScreen.main.bounds
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bgView.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.3)

        let blurEffect = UIBlurEffect(style: .light)
        blurview = UIVisualEffectView(effect: blurEffect)
        blurview.alpha = 0.95
        self.addSubview(blurview!)
        blurview.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview()
        }

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.alpha = 0.95
        blurview.contentView.addSubview(vibrancyView)
        vibrancyView.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview()
        }

        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(self.kImageViewTopMargin)
            make.width.equalTo(0)
            make.height.equalTo(0)
        }

        addSubview(self.bottomView)
        
        self.bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(self.bottomContentHeight())
            make.bottom.equalToSuperview()
        }

    }

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()

    lazy var bgView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var bottomView: YWShareBottomAlertView = {
        let view = YWShareBottomAlertView()
        view.isDefaultShowMessage = true
        return view
    }()


    lazy var cancelButton: UIControl = {
        let view = UIControl()
        view.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return view
    }()
    

    @objc func cancelButtonAction() {
        self.hideShareView()
    }

}



