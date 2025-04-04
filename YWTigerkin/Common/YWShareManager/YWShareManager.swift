////
////  YWShareManager.swift
////  YWTigerkin
////
////  Created by odd on 7/16/23.
////
//
//import UIKit
//import MessageUI
//
//@objc enum YWSharePlatform: Int {
//    case ywUnknow
//    case wechat
//    case wechatFriend
//    case sinaweibo
//    case QQ
//    case wxMiniProgram
//    case twitter
//    case facebook
//    case facebookMessenger
//    case whatsApp
//    case instagram
//    case line
//    case telegram
//    case sms
//    case ywMore
//    case ywCollect
//    case ywSaveImage
//    case ywCopy
//    case ywuSocial
//    
//    var SSDKPlatform: SSDKPlatformType {
//        switch self {
//        case .wechat:
//            return .typeWechat
//        case .wechatFriend:
//            return .subTypeWechatTimeline
//        case .sinaweibo:
//            return .typeSinaWeibo
//        case .QQ:
//            return .typeQQ
//        case .facebook:
//            return .typeFacebook
//        case .twitter:
//            return .typeTwitter
//        case .instagram:
//            return .typeInstagram
//        case .telegram:
//            return .typeTelegram
//        default:
//            return .typeUnknown
//        }
//    }
//
//}
//
//@objc enum YWShareType: Int {
//    case link
//    case image
//}
//
//class YWShareConfig: NSObject {
//    
//    
//    @objc var shareType:YWShareType = .link
//    @objc var imageData: Any?
//
//    //分享按钮集合
//    var thirdItems:[YWSharePlatform] = []
//    //工具分享集合
//    var toolsItems:[YWSharePlatform] = []
//    
//
//    //@objc var shareType: String?
//    @objc var title: String = ""
//    @objc var desc: String = ""  //description
//    @objc var shortUrl: String = "" //二维码
//    @objc var pageUrl: String = ""
//    @objc var thumbUrl: String?
//    @objc var wechatDescription: String = ""
//    
//    @objc var overseaPageUrl: String?
//    @objc var wxUserName: String?
//    @objc var wxPath: String?     //小程序分享path
//    @objc var withShareTicket: Bool = false
//    @objc var miniProgramType: UInt = 0
//    @objc var isDialogBgNone: Bool = false
//    
//
//    @objc var followLogin: Bool = true  //是否跟随用户登录态
//    @objc var longUrl: String = ""
//    @objc var splicingQRView = true //图片分享时是否要拼接二维码视图
//    
//    @objc var subPlatform: YWSharePlatform = .ywUnknow
//    @objc var subImage: UIImage?
//    
//    @objc var isMoreTop = false
//    
//    @objc var showWework = true
//
//    //视图相关配置
//    @objc var lrMargin: CGFloat = (30.0 * YWConstant.screenWidth / 375.0)
//    @objc var cornerRadius: CGFloat = 0
//    
//    //分享小程序配图
//    @objc var miniProgramImage: UIImage?
//    
//    //内部默认统一弹出提示
//    @objc var isDefaultShowMessage = false
//    
//    @objc class func linkConfig(title: String = "", desc: String = "", shortUrl: String = "", pageUrl: String = "", wechatDescription: String = "", thumbUrl: String? = nil) -> YWShareConfig {
//        let config = YWShareConfig()
//        config.title = title
//        config.desc = desc
//        config.shortUrl = shortUrl
//        config.pageUrl = pageUrl
//        config.wechatDescription = wechatDescription
//        config.thumbUrl = thumbUrl
//        return config
//    }
//
//}
//
//class YWShareManager: NSObject {
//
//    @objc static let shared = YWShareManager()
//    
//    typealias ResultBlock = (_ platform: YWSharePlatform, _ result: Bool, _ onlyTap:Bool) -> Void
//    
//    typealias ConfigBlock = (_ platform: YWSharePlatform) -> YWShareConfig?
//    
//}
//
//
//
////MARK: - 展示方法
//extension YWShareManager {
//    //链接、图片分享
//    @objc func share(_ config: YWShareConfig, shareResultBlock: ResultBlock?) {
//       
//        self.share(config, configBlock: nil,shareResultBlock: shareResultBlock)
//    }
//    
//    /// 分享的通用方法
//    /// - Parameters:
//    ///   - config: 配置信息
//    ///   - configBlock: 获取某个平台独有的配置信息 如：  "\(title)\n\n\(description ?? "")\n\(shortUrl ?? "")" 及  "\(title)\n\(shortUrl ?? "")" 可以配置 config.desc为空来实现
//    ///   - itemViewBlock: 获取额外配置的平台 eg. 收藏，字体等和页面关联紧密的视图
//    ///   - shareResultBlock: 分享结果
//    @objc private func share(_ config: YWShareConfig, configBlock: ConfigBlock? = nil, shareResultBlock: ResultBlock? = nil) {
//        
//        if config.shareType == .image {
//            
//            if config.imageData == nil {
//                YWLog("分享：缺少关键图片")
//                return
//            }
//            
//            loadServerConfig(.image, config: config) {
//                 [weak self] in
//                guard let `self` = self else { return }
//                self.showImagePlatformView(config, configBlock: configBlock,shareResultBlock: shareResultBlock)
//            }
//        } else {
//            loadServerConfig(.link, config: config) {
//                 [weak self] in
//                guard let `self` = self else { return }
//                self.showImagePlatformView(config, configBlock: configBlock,shareResultBlock: shareResultBlock)
//            }
//        }
//        
//    }
//    
//    
//    private func loadServerConfig(_ shareType: YWShareType, config: YWShareConfig, excute:(() -> Void)?) {
//        excute?()
//    }
//    private func showLinkPlatformView(_ config: YWShareConfig, configBlock: ConfigBlock?, shareResultBlock: ResultBlock?) {
//        
//        func shareTo(_ platform: YWSharePlatform) {
//            var tempConfig = config
//            if let configgg = configBlock?(platform) {
//                tempConfig = configgg
//            }
////            if YWShareManager.isNeedHiddeModalPresent(platform) {
////                if let modalVC =  UIViewController.current() as? PresentationViewController {
////                    modalVC.hideWith(animated: false, completion: { finished in
////                        self.shareLink(to: platform, config: tempConfig, shareResultBlock: shareResultBlock)
////
////                    })
////                    return
////                }
////            }
//            //只是点击
//            shareResultBlock?(platform,false,true)
//            self.shareContent(to: platform, config: tempConfig, shareResultBlock: shareResultBlock)
//        }
//        
//        let shareView = YWShareImageContentView(frame: UIScreen.main.bounds, shareType: .link, toolTypes: config.toolsItems,thirdTypes: config.thirdItems) { shareItem in
//            if shareItem.sharePlatform == .ywUnknow {
//            } else {
//                shareTo(shareItem.sharePlatform)
//            }
//        } cancelCallBlock: {
//        }
//        shareView.isDefaultShowMessage = config.isDefaultShowMessage
//        shareView.showShareView()
//    }
//    
//    
//    private func showImagePlatformView(_ config: YWShareConfig, configBlock: ConfigBlock?, shareResultBlock: ResultBlock?) {
//        
//        func shareTo(_ platform: YWSharePlatform) {
//            
//            var tempConfig = config
//            if let configgg = configBlock?(platform) {
//                tempConfig = configgg
//            }
////            if YWShareManager.isNeedHiddeModalPresent(platform) {
////                if let modalVC =  UIViewController.current() as? PresentationViewController {
////                    modalVC.hideWith(animated: false, completion: { finished in
////                        self.shareLink(to: platform, config: tempConfig, shareResultBlock: shareResultBlock)
////
////                    })
////                    return
////                }
////            }
//            //只是点击
//            shareResultBlock?(platform,false,true)
//            self.shareContent(to: platform, config: tempConfig, shareResultBlock: shareResultBlock)
//        }
//        
//        let shareView = YWShareImageContentView(frame: UIScreen.main.bounds, shareType: .image, toolTypes: config.toolsItems,thirdTypes: config.thirdItems) { shareItem in
//            
//            if shareItem.sharePlatform == .ywUnknow {
//                
//            } else {
//                shareTo(shareItem.sharePlatform)
//            }
//            
//            
//        } cancelCallBlock: {
//            
//        }
//        //如果是图片数据，先转
//        if let img = config.imageData as? UIImage {
//            shareView.shareImage = img
//        }
//        
//        shareView.isDefaultShowMessage = config.isDefaultShowMessage
//        shareView.showShareView()
//    }
//    
//    
//}
//
////MARK: - 分享方法
//extension YWShareManager {
//    
//    // MARK: - 注意事项
//    /**
//     telegram: 只支持纯图片 或 链接（图片分享时，如果telegram没有登录，就会弹出登录提示，所以使用more)
//     Instagram: 不支持链接文字分享
//     line平台分享链接时，如果传了图片，就只有图片了
//     
//     图片 + 文案：微博、Twitter
//     只能图片的：Line、Instagram、Facebook、Messenger、微信、朋友圈、qq、空间、企业微信、WhatsApp
//    注意：twitter传图文时，给text, 给title不行。 微博，两个都可以
//     
//     // FB链接分享，需要隐藏弹窗，不然会报 SFSafariViewController's parent view controller was dismissed（因为会调用APP内部网页FB登录界面）
//     */
//    @objc func isShareImageWithTitle(_ platform: YWSharePlatform) -> Bool {
//        //platform == .telegram
//        if platform == .twitter || platform == .sinaweibo {
//            return true
//        }
//        return false
//    }
//    
//    @objc func isShareImageWithTitleSSDKType(_ platform: YWSharePlatform) -> Bool {
//        if platform == .twitter || platform == .sinaweibo {
//            return true
//        }
//        return false
//    }
//    
//    // 点击分享，判断对应的是否要先隐藏弹窗
//    @objc class func isNeedHiddeModalPresent(_ platform: YWSharePlatform) -> Bool {
//        // FB链接分享，需要隐藏弹窗，不然会报 SFSafariViewController's parent view controller was dismissed（因为会调用APP内部网页FB登录界面）
//        if platform == .ywMore || platform == .sms || platform == .facebook {
//            return true
//        }
//        return false
//    }
//    
//    @objc class func showShareResultMessage(sharePlatform:YWSharePlatform, success:Bool) {
//        
//        var kkWindow: UIWindow?
//        kkWindow = YWConstant.kKeyWindow()
//        
//        if let window = kkWindow {
//            switch sharePlatform {
//            case .ywCopy:
//                if success {
//                    YWProgressHUD.showMessage("copy_success",in: window)
//                }
//            case .ywSaveImage:
//                if success {
//                    YWProgressHUD.showMessage(YWLanguageUtility.kLang(key: "user_saveSucceed"),in: window)
//                }else {
//                    YWProgressHUD.showMessage(YWLanguageUtility.kLang(key: "user_saveFailed"),in: window)
//                }
//                break
//            case .ywMore,.telegram:
//                print("more 不分享")
//                break
//            default:
//                if success {
//                    YWProgressHUD.showError(YWLanguageUtility.kLang(key: "share_succeed"), in: window)
//
//                } else {
//                    YWProgressHUD.showError(YWLanguageUtility.kLang(key: "share_failed"), in: window)
//
//                }
//            }
//        }
//    }
//    
//    @objc class func shareToCommunity(_ image: UIImage?) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            if !YWUserManager.isLogin() {
//                //
//                return
//            }
//
//            if let root = UIApplication.shared.delegate as? YWAppDelegate {
//                let navigator = root.navigator
//                //navigator.push(viewModel, animated: true)
//            }
//        }
//    }
//    
//    //MARK: 主分享截图 带默认文案
//    @objc private func shareImage(to platform: YWSharePlatform, shareImage: UIImage?, shareResultBlock: ResultBlock? = nil) {
//        
//        guard let image = shareImage else {
//            return
//        }
//        
//        var shareAppText = ""
//        if isShareImageWithTitle(platform) {
//            shareAppText = YWLanguageUtility.kLang(key: "share_image_recommend_text")
//        }
//
//        YWShareSDKHelper.instance.share(platform.SSDKPlatform, text: shareAppText, images: [image], url: nil, title: "", type: .image, callback: { (success, userInfo, _) in
//            shareResultBlock?(platform, success, false)
//        })
//    
//    }
//    
//    //MARK: 主分享文案， url 图片icon、图片链接
//    @objc private func shareTextImage(to platform: YWSharePlatform, text: String?, images: Any?, url: URL?, title: String?, contentType: SSDKContentType = .auto, shareResultBlock: ResultBlock? = nil) {
//        
//        YWShareSDKHelper.instance.share(platform.SSDKPlatform, text: (text ?? ""), images: images, url:  nil, title: (title ?? ""), type: contentType){ (success, userInfo, _) in
//            shareResultBlock?(platform, success, false)
//        }
//    }
//    
//    
//    //MARK: 分享数据处理
//    @objc private func shareContent(to platform: YWSharePlatform, config: YWShareConfig, shareResultBlock: ResultBlock?) {
//
//        if platform == .ywUnknow || platform == .sinaweibo || platform == .QQ {
//            shareResultBlock?(platform, false, false)
//            return
//        }
//
//        var images: Any?
//        if let url = config.thumbUrl, !url.isEmpty {
//            images = url
//        } else {
//            images = UIImage(named: "logo_60")
//        }
//
//        if config.wechatDescription.isEmpty {
//            config.wechatDescription = config.desc
//        }
//
//        var sharingImage: UIImage?
//        //var sharingImage = YWToolUtility.conventToImage(withBase64String: config.imageData)
//        //if let subImage = config.subImage, sharingImage == nil {
//        //    sharingImage = subImage
//        //}
//        
//        if platform == .ywCopy {
//            //复制链接
//            let pab = UIPasteboard.general
//
//            var shareString = config.title
//
//            if !config.desc.isEmpty {
//                shareString += ("\n\n" + config.desc)
//            }
//
//            shareString += ("\n" + (config.shortUrl.isEmpty ? config.pageUrl : config.shortUrl))
//
//            pab.string = shareString
//
//            //YWProgressHUD.showMessage(YWLanguageUtility.kLang(key: "copy_success"))
//            shareResultBlock?(platform, true,false)
//
//        } else if platform == .ywMore || (platform == .telegram && sharingImage != nil)  {//telegram 图片分享暂时用more功能,(telgram用长链)
//        
//            //block回调 present
//            let presentBlock:((_ image:UIImage?) -> Void) = { [weak self] (image) in
//                guard let `self` = self else { return }
//
//                var items: [Any] = []
//        
//                var shareString = config.title
//                if !config.desc.isEmpty {
//                    if shareString.count > 0 {
//                        shareString += "\n\n"
//                    }
//                    shareString += config.desc
//                }
//
//                if !shareString.isEmpty {
//                    items.append(shareString)
//                }
//
//                if let img = image {
//                    items.append(img)
//                }
//
//                if let shortURL = URL(string: config.shortUrl) {
//                    items.append(shortURL)
//                } else if let pageUrl = URL(string: config.pageUrl) {
//                    items.append(pageUrl)
//                }
//                if platform == .telegram,let img = image {// telegram 只分享图片 后续调试带文案的
//                    items = [img]
//                }
//                
//                if items.count > 0 {
//                    self.shareToMore(activityItems: items, shareResultBlock: shareResultBlock)
//                    
//                }
//                
//            }
//            if let shareImage = sharingImage {
//                presentBlock(shareImage)
//            } else {
//                //下载图片
//                if let tempThumbUrl = config.thumbUrl, tempThumbUrl.isEmpty == false, let temp = URL(string: tempThumbUrl) {
//                    let progressHUD = YWProgressHUD.showLoading("", in: YWConstant.kKeyWindow())
//
////                    SDWebImageManager.shared.loadImage(with: temp, options: .retryFailed, progress: nil) { image, data, error, cacheType, finished, imageURL in
////                        progressHUD.hide(animated: true)
////                        presentBlock(image)
////                    }
//                } else {
//                    presentBlock(nil)
//                }
//            }
//            
//        } else if platform == .wxMiniProgram {
//
//            if let pageURL = URL(string: config.pageUrl), YWShareSDKHelper.isClientIntalled(.typeWechat) {
////                YWShareSDKHelper.instance.shareMiniProgram(by: .typeWechat, title: config.title, description: config.desc, webpageUrl: pageURL, path: config.wxPath, thumbImage: images, hdThumbImage: images, userName: config.wxUserName, withShareTicket: config.withShareTicket, miniProgramType: config.miniProgramType, forPlatformSubType: .subTypeWechatSession, callback: { (success, userInfo, _) in
////                    shareResultBlock?(platform, success)
////                })
//            } else {
//                shareResultBlock?(platform, false,false)
//            }
//
//        } else if platform == .sms {
//            var desc: String? = config.title + "\n" + config.shortUrl
//            if config.subImage != nil {
//                desc = nil
//            }
//            self.shareToMessage(content: desc, sharingImage: sharingImage, imageUrlString: config.thumbUrl) { result in
//                shareResultBlock?(platform, result,false)
//            }
//        } else {
//
//            if platform == .wechat || platform == .wechatFriend {
//                if !YWShareSDKHelper.isClientIntalled(.typeWechat) {
//                    shareResultBlock?(platform, false, false)
//                    return;
//                }
//            } else if platform == .whatsApp {
//                if !YWShareSDKHelper.isClientIntalled(.typeWhatsApp) {
//                    shareResultBlock?(platform, false, false)
//                    return;
//                }
//            } else if platform == .facebookMessenger {
//                if !YWShareSDKHelper.isClientIntalled(.typeFacebookMessenger) {
//                    shareResultBlock?(platform, false, false)
//                    return;
//                }
//            }
//
//            if let shareImage = sharingImage {
//                YWShareManager.shared.shareImage(to: platform, shareImage: shareImage, shareResultBlock: { platform, result, tap in
//                    shareResultBlock?(platform, result, tap)
//                })
//                
//            } else {
//                var url: URL?
//                var contentType: SSDKContentType = .auto
//                url = URL(string: config.pageUrl)
//                if config.longUrl == config.pageUrl && !config.shortUrl.isEmpty && platform != .facebook && platform != .telegram{
//                    //longUrl 和 pageUrl相同时， shortUrl为longUrl转变的短链
//                    url = URL(string: config.shortUrl)
//                }
//
//                var desc: String = config.desc
//                if platform == .wechat, !config.wechatDescription.isEmpty {
//                    desc = config.wechatDescription
//                }
//                
//                if platform == .facebook {
//                    if let overseaUrl = config.overseaPageUrl, !overseaUrl.isEmpty {
//                        url = URL(string: overseaUrl)
//                    }
//                    if YWShareSDKHelper.isClientIntalled(.typeFacebook) { // facebook 只支持网络图片
//                        images = config.thumbUrl
//                    } else {
//                        images = nil
//                    }
//                } else if platform == .facebookMessenger {
//                    if let overseaUrl = config.overseaPageUrl, !overseaUrl.isEmpty {
//                        url = URL(string: overseaUrl)
//                    }
//                    images = config.thumbUrl
//                } else if platform == .twitter {
//                    if let overseaUrl = config.overseaPageUrl, !overseaUrl.isEmpty {
//                        url = URL(string: overseaUrl)
//                    }
//                    if let shortURL = URL(string: config.shortUrl) { //分享链接
//                        url = shortURL
//                        images = nil
//                        contentType = .webPage
//                        config.title = ""
//                    }
//                } else if platform == .whatsApp {
//                    desc = config.title
//                    if !config.desc.isEmpty {
//                        if desc.count > 0 {
//                            desc += "\n\n"
//                        }
//                        desc += config.desc
//                    }
//                    if !config.shortUrl.isEmpty {
//                        desc += "\n\(config.shortUrl)"
//                    }
//                    images = nil
//                    url = nil
//                    config.title = ""
//                }
//                
//                //line平台分享链接时，如果传了图片，就只有图片了
//                if platform == .line || platform == .telegram {
//                    images = nil
//                }
//
////                if config.subPlatform == .wxMiniProgram, platform == .wechat {
//                    
////                    var miniProgramType: UInt = 0
////                    if YXConstant.targetMode() == .prd || YXConstant.targetMode() == .prd_hk {
////                        miniProgramType = 0
////                    } else {
////                        miniProgramType = 2
////                    }
//                    
////                    if let miniProgramImage = config.miniProgramImage {
////                        images = miniProgramImage
////                    }
//               
//                    //TODO:屏蔽分享功能
////                    YWShareSDKHelper.shareInstance()?.shareMiniProgram(by: .typeWechat, title: config.title, description: config.desc, webpageUrl: url, path: config.wxPath, thumbImage: images, hdThumbImage: images, userName: WXMiniProgramUserName, withShareTicket: false, miniProgramType: miniProgramType, forPlatformSubType: .subTypeWechatSession, callback: { (success, userInfo, _) in
////                        shareResultBlock?(platform, success)
////                    })
////                } else {
////
////                    YWShareManager.shared.shareTextImage(to: platform, text: desc, images: images, url: url, title: config.title, contentType: contentType) { platform, result, tap  in
////                        shareResultBlock?(platform, result, tap)
////                    }
////
////                }
//
//
//                //分享微博时，必须有图片
//                YWShareManager.shared.shareTextImage(to: platform, text: desc, images: images, url: url, title: config.title, contentType: contentType) { platform, result, tap  in
//                    shareResultBlock?(platform, result, tap)
//                }
//                
//            }
//
//        }
//    }
//    
//    
//    // more分享不给提示
//    private func shareToMore(activityItems: [Any], shareResultBlock: ResultBlock?) {
//        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
//        let completeBlock: UIActivityViewController.CompletionWithItemsHandler = { [weak vc] (activityType, completed, items, error) in
//            guard let strongVC = vc else { return }
//            if let shareBlock = shareResultBlock {
//                shareBlock(.ywMore, completed,false)
//            }
//            if completed {
//                YWLog("information: send success")
//            } else {
//                YWLog("information: send failed")
//            }
//            strongVC.dismiss(animated: true, completion: nil)
//        }
//        vc.completionWithItemsHandler = completeBlock
//        UIViewController.current().present(vc, animated: true, completion: nil)
//    }
//    
//    //MARK: 1.分享到短信
//    private func shareToMessage(content: String?, sharingImage: UIImage?, imageUrlString: String?, shareResultBlock: ((Bool) -> Void)?) {
//        // 分享短信
//        // 1.判断能不能发短信
//        if MFMessageComposeViewController.canSendText() {
//            // 开始转菊花，进行图片下载
//            
//            let c = MFMessageComposeViewController()
//            c.shareResultBlock = shareResultBlock
//            c.body = content
//            c.messageComposeDelegate = self
//            let presentBlock: (_ image:UIImage?) -> Void = {[weak c] (image) in
//                guard let strongC = c else {return}
//                if let data = image?.pngData(), data.count > 0 {
//                    strongC.addAttachmentData(data, typeIdentifier: "public.png", filename: "icon.png")
//                    UIViewController.current().present(strongC, animated: true, completion: nil)
//                }
//                else if let data = image?.jpegData(compressionQuality: 1), data.count > 0 {
//                    strongC.addAttachmentData(data, typeIdentifier: "public.jpeg", filename: "icon.png")
//                    UIViewController.current().present(strongC, animated: true, completion: nil)
//                }
//                else {
//                    UIViewController.current().present(strongC, animated: true, completion: nil)
//                }
//            }
//            if MFMessageComposeViewController.canSendAttachments() {
//                // 1. 仅支持jpg、png图片的短信分享
//                // 2. 图片需要做缓存
//                // 3. 图片下载完成后，present vc && 隐藏菊花
//                // 4. 图片下载失败后，present vc (without image) && 隐藏菊花
//                // 5. 没有需要分享的图片链接时，不需要分享图片
//                // https://developer.apple.com/documentation/messageui/mfmessagecomposeviewcontroller/1614075-issupportedattachmentuti
//                if MFMessageComposeViewController.isSupportedAttachmentUTI("public.png") ||
//                    MFMessageComposeViewController.isSupportedAttachmentUTI("public.jpeg") {
//                    if let sharingImage = sharingImage {
//                        presentBlock(sharingImage)
//                    } else {
//                        if let imageUrlString = imageUrlString,imageUrlString.isEmpty == false {
////                            let hud = YWProgressHUD.showLoading("")
////                            let temp = URL(string: imageUrlString)!
////                            SDWebImageManager.shared.loadImage(with: temp, options: SDWebImageOptions.retryFailed, progress: { (_, _, _) in
////
////                            }) { (image, data, error, cacheType, finished, imageURL) in
////                                hud.hide(animated: true)
////                                presentBlock(image)
////                            }
//                        } else {
//                            presentBlock(nil)
//                        }
//                    }
//                } else {
//                    presentBlock(nil)
//                }
//            } else {
//                presentBlock(nil)
//            }
//        } else {
//            // 不能发短信时
//            shareResultBlock?(false)
//            YWProgressHUD.showMessage("share_not_support_message", in: YWConstant.kKeyWindow(), hideAfterDelay: 2.0)
//        }
//    }
//    
//    //MARK: - 分享平台配置
//    //传入nil，取默认
//    class func getThirdShareItems(_ sharePlatforms:[YWSharePlatform]?,_ shareType:YWShareType) -> [YWShareItemModel] {
//        
//        var thirdShareDatas:[YWShareItemModel] = []
//        
//        //默认
//        var defaultPlatforms:[YWSharePlatform] = [.wechat,.sinaweibo,.QQ,.facebook,.whatsApp,.twitter,.telegram,.line]
//        if shareType == .image {
//            defaultPlatforms = [.wechat,.sinaweibo,.QQ,.facebook,.whatsApp,.twitter,.instagram,.ywuSocial,.telegram,.line]
//        }
//        if let platforms = sharePlatforms {
//            defaultPlatforms = platforms
//        }
//        
//        for platform in defaultPlatforms {
//            switch platform {
//            case .ywuSocial:
//                let communityModel = YWShareItemModel.init()
//                communityModel.shareName = YWLanguageUtility.kLang(key: "share_community")
//                communityModel.shareImageName = "share_community"
//                communityModel.shareType = "shareUsmartCommunity"
//                communityModel.sharePlatform = YWSharePlatform.ywuSocial
//                thirdShareDatas.append(communityModel)
//            case .whatsApp:
//                if YWShareSDKHelper.isClientIntalled(.typeWhatsApp) {
//                    
//                    let whatsAppModel = YWShareItemModel.init()
//                    whatsAppModel.shareName = YWLanguageUtility.kLang(key: "share_whatsApp")
//                    whatsAppModel.shareImageName = "share_WhatsApp"
//                    whatsAppModel.sharePlatform = YWSharePlatform.whatsApp
//                    thirdShareDatas.append(whatsAppModel)
//                }
//            case .telegram:
//                if YWShareSDKHelper.isClientIntalled(.typeTelegram) {
//                    let whatsAppModel = YWShareItemModel.init()
//                    whatsAppModel.shareName = YWLanguageUtility.kLang(key: "share_telegram")
//                    whatsAppModel.shareImageName = "share_telegram"
//                    whatsAppModel.sharePlatform = YWSharePlatform.telegram
//                    thirdShareDatas.append(whatsAppModel)
//                }
//            case .line:
//                if YWShareSDKHelper.isClientIntalled(.typeLine) {
//                    let lineAppModel = YWShareItemModel.init()
//                    lineAppModel.shareName = YWLanguageUtility.kLang(key: "share_line")
//                    lineAppModel.shareImageName = "share_line"
//                    lineAppModel.sharePlatform = YWSharePlatform.line
//                    thirdShareDatas.append(lineAppModel)
//                }
//            case .facebook:
//                let fbModel = YWShareItemModel.init()
//                fbModel.shareName = YWLanguageUtility.kLang(key: "share_facebook")
//                fbModel.shareImageName = "share_fb"
//                fbModel.sharePlatform = YWSharePlatform.facebook
//                thirdShareDatas.append(fbModel)
////            case .facebookMessenger://没有
////                if YWShareSDKHelper.isClientIntalled(.typeFacebookMessenger) {
////
////                    let fbMessagerModel = YWShareItemModel.init()
////                    fbMessagerModel.shareName = YWShareSDKHelper.title(forPlatforms: .typeFacebookMessenger)
////                    fbMessagerModel.shareImageName = "share-fb-messenger"
////                    fbMessagerModel.sharePlatform = YWSharePlatform.facebookMessenger
////                    thirdShareDatas.append(fbMessagerModel)
////                }
//            case .wechat://海外不支持
//                if YWShareSDKHelper.isClientIntalled(.typeWechat) {
//
//                    let wechatModel = YWShareItemModel.init()
//                    wechatModel.shareName = YWLanguageUtility.kLang(key: "share_wechat")
//                    wechatModel.shareImageName = "share_wechat"
//                    wechatModel.sharePlatform = YWSharePlatform.wechat
//                    thirdShareDatas.append(wechatModel)
//
//                    let wechatMomentModel = YWShareItemModel.init()
//                    wechatMomentModel.shareName = YWLanguageUtility.kLang(key: "share_wechatFriend")
//                    wechatMomentModel.shareImageName = "share_moments"
//                    wechatMomentModel.sharePlatform = YWSharePlatform.wechatFriend
//                    thirdShareDatas.append(wechatMomentModel)
//
//                }
//            case .twitter:
//                let twitterModel = YWShareItemModel.init()
//                twitterModel.shareName = YWLanguageUtility.kLang(key: "share_twitter")
//                twitterModel.shareImageName = "share_twitter"
//                twitterModel.sharePlatform = YWSharePlatform.twitter
//                thirdShareDatas.append(twitterModel)
//            case .instagram:
//                if YWShareSDKHelper.isClientIntalled(.typeInstagram) && shareType != .link{//不支持链接文字分享
//                    let twitterModel = YWShareItemModel.init()
//                    twitterModel.shareName = YWLanguageUtility.kLang(key: "share_instagram")
//                    twitterModel.shareImageName = "share_Instagram"
//                    twitterModel.sharePlatform = YWSharePlatform.instagram
//                    thirdShareDatas.append(twitterModel)
//                }
////            case .sms:
////                let twitterModel = YWShareItemModel.init()
////                twitterModel.shareName = YWLanguageUtility.kLang(key: "share_message")
////                twitterModel.shareImageName = "share-message"
////                twitterModel.sharePlatform = YWSharePlatform.sms
////                thirdShareDatas.append(twitterModel)
//            default:
//                print("未知平台")
//            }
//        }
//        
//        
//        for (i,item) in thirdShareDatas.enumerated() {
//            item.shareTag = 1000+i
//        }
//        return thirdShareDatas
//    }
//    
//    //传入nil，取默认
//    class func getToolShareItems(_ sharePlatforms:[YWSharePlatform]?) -> [YWShareItemModel] {
//        
//        
//        var defaultPlatforms:[YWSharePlatform] = [.ywMore]
//        if let platforms = sharePlatforms {
//            defaultPlatforms = platforms
//        }
//        
//        var toolsShareDatas:[YWShareItemModel] = []
//
//        for platform in defaultPlatforms {
//            switch platform {
//            case .ywSaveImage:
//                let saveImageModel = YWShareItemModel.init()
//                saveImageModel.shareName = YWLanguageUtility.kLang(key: "share_save_pic")
//                saveImageModel.shareImageName = "share_save"
//                saveImageModel.sharePlatform = YWSharePlatform.ywSaveImage
//                toolsShareDatas.append(saveImageModel)
//            case .ywCopy:
//                let copyModel = YWShareItemModel.init()
//                copyModel.shareName = YWLanguageUtility.kLang(key: "share_copy_url")
//                copyModel.shareImageName = "share_copy"
//                copyModel.sharePlatform = YWSharePlatform.ywCopy
//                toolsShareDatas.append(copyModel)
//            case .ywMore:
//                let moreModel = YWShareItemModel.init()
//                moreModel.shareName = YWLanguageUtility.kLang(key: "share_more")
//                moreModel.shareImageName = "share_more"
//                moreModel.sharePlatform = YWSharePlatform.ywMore
//                toolsShareDatas.append(moreModel)
//            default:
//                print("未知平台")
//            }
//        }
//
//        for (i,item) in toolsShareDatas.enumerated() {
//            item.shareTag = 100+i
//        }
//       
//        return toolsShareDatas
//    }
//}
//
////MARK: - MFMessageComposeViewControllerDelegate
//extension YWShareManager: MFMessageComposeViewControllerDelegate {
//    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//        UIViewController.current().dismiss(animated: true, completion: nil)
//        switch result {
//        case .sent:
//            controller.shareResultBlock!(true)
//            print("webview: send message success")
//        case .failed:
//            controller.shareResultBlock!(false)
//            print("webview: send message failed")
//        default:
//            controller.shareResultBlock!(false)
//            print("webview: default")
//        }
//    }
//}
//
//public extension MFMessageComposeViewController {
//    private struct AssociatedKey {
//        static var shareResultBlockk: String = "shareResultBlockk"
//    }
//    var shareResultBlockk: ((Bool) -> Void)? {
//        get {
//            (objc_getAssociatedObject(self, &AssociatedKey.shareResultBlockk) as! (Bool) -> Void)
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedKey.shareResultBlockk, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//    }
//}
