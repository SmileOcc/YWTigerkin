////
////  YWShareSDKHelper.swift
////  YWTigerkin
////
////  Created by odd on 7/22/23.
////
//
//import UIKit
//
//
//#if DEV
//let kYW_UNIVERSAL_LINKS = "https://ywTigerkin.xx.com"
//let kYW_WECHAT_UNIVERSAL_LINKS = "https://ywTigerkin.xx.com/app_universal_links/"
//
//#else
//let kYW_UNIVERSAL_LINKS = "https://ywTigerkin.xx.com"
//let kYW_WECHAT_UNIVERSAL_LINKS = "https://ywTigerkin.xx.com/app_universal_links/"
//
//#endif
//
//
////MARK: - 微信平台的配置信息
//#if DEV
//let kMOBSSDKWeChatAppID = "wx623111111"
////AppSecret
//let kMOBSSDKWeChatAppSecret = "a99151111"
//
//#elseif PRD
//let kMOBSSDKWeChatAppID = "wx623111111"
////AppSecret
//let kMOBSSDKWeChatAppSecret = "a99151111"
//#else
//
//let kMOBSSDKWeChatAppID = "wx623111111"
////AppSecret
//let kMOBSSDKWeChatAppSecret = "a99151111"
//
//#endif
//
////MARK: - 微信平台的配置信息
//#if DEV
////AppID
//let kMOBSSDKFacebookAppID = ""
////AppSecret
//let kMOBSSDKFacebookAppSecret = ""
////displayName facebook客户端分享必须
//let kMOBSSDKFacebookDisplayName = "YW"
//
//#else
////AppID
//let kMOBSSDKFacebookAppID = ""
////AppSecret
//let kMOBSSDKFacebookAppSecret = ""
////displayName facebook客户端分享必须
//let kMOBSSDKFacebookDisplayName = "YW"
//#endif
//
//
////MARK: - Twitter平台配置信息
//#if DEV
//let kMOBSSDKTwitterConsumerKey = ""
////ConsumerSecret
//let kMOBSSDKTwitterConsumerSecret = ""
////RedirectUri
//let kMOBSSDKTwitterRedirectUri = ""
//
//#else
//let kMOBSSDKTwitterConsumerKey = ""
////ConsumerSecret
//let kMOBSSDKTwitterConsumerSecret = ""
////RedirectUri
//let kMOBSSDKTwitterRedirectUri = ""
//#endif
//
//
////MARK: - Instagram平台配置信息
//#if DEV
////AppID
//let kMOBSSDKInstagramAppID  = ""
////AppSecret
//let kMOBSSDKInstagramAppSecret = ""
////displayName facebook客户端分享必须
//let kMOBSSDKInstagramRedirectUri = ""
//
//#else
////AppID
//let kMOBSSDKInstagramAppID  = ""
////AppSecret
//let kMOBSSDKInstagramAppSecret = ""
////displayName facebook客户端分享必须
//let kMOBSSDKInstagramRedirectUri = ""
//#endif
//
//
//typealias ShareCallBlock = (_ success: Bool, _ userInfo: [String:Any]?, _ platform:SSDKPlatformType) -> Void
//
//
class YWShareSDKHelper: NSObject {
//
    static let instance: YWShareSDKHelper = YWShareSDKHelper()
//    
//    var isAuth: Bool = false
    var isTestAllPlatform = false
//    
//    static func isClientIntalled(_ platformType: SSDKPlatformType) -> Bool {
//        
//        #if DEV
//        if YWShareSDKHelper.instance.isTestAllPlatform {
//            return true
//        }
//        #endif
//        return ShareSDK.isClientInstalled(platformType)
//    }
//    
//    static func registerPlatforms() {
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            ShareSDK.registPlatforms { platformsRegister in
//                YWLog("注册分享")
//                platformsRegister?.setupWeChat(withAppId: kMOBSSDKWeChatAppID, appSecret: kMOBSSDKWeChatAppSecret, universalLink: kYW_WECHAT_UNIVERSAL_LINKS)
//                
//                platformsRegister?.setupFacebook(withAppkey: kMOBSSDKFacebookAppID, appSecret: kMOBSSDKFacebookAppSecret, displayName: kMOBSSDKFacebookDisplayName)
//                
//                platformsRegister?.setupTwitter(withKey: kMOBSSDKTwitterConsumerKey, secret: kMOBSSDKTwitterConsumerSecret, redirectUrl: kMOBSSDKTwitterRedirectUri)
//                
//                platformsRegister?.setupInstagram(withClientId: kMOBSSDKInstagramAppID, clientSecret: kMOBSSDKInstagramAppSecret, redirectUrl: kMOBSSDKInstagramRedirectUri)
//                
//                platformsRegister?.setupLineAuthType(.both)
//            }
//        })
//    }
//    
//    //MARK: - Authorize Methods
//
//    func authorize(_ platformType: SSDKPlatformType, callBack: @escaping ShareCallBlock) {
//        if isAuth {
//            return
//        }
//        
//        isAuth = true
//        let setting = NSDictionary()
//        
//        
//        ShareSDK.authorize(platformType, settings: setting as? [AnyHashable : Any]) { [weak self] (state, user, error) in
//            guard let `self` = self else {return}
//            self.isAuth = false
//            
//            switch state {
//            case .success:
//                if let dic = user?.dictionaryValue() as? [String: Any] {
//                    callBack(true, dic, platformType)
//                } else {
//                    callBack(true,[:], platformType)
//                }
//                break
//            case .fail:
//                if let nsError = error as NSError?, nsError.code == 200301 {//取消授权
//                    callBack(false,[:], platformType)
//                } else {
//                    callBack(false,["error":error as Any], platformType)
//                }
//                break
//            case .cancel:
//                callBack(false, [:], platformType)
//                break
//            default:
//                callBack(false,nil,platformType)
//                break
//            }
//        }
//    }
//    
//    func cancelAuthorize(plaformType: SSDKPlatformType, callback: @escaping ShareCallBlock) {
//        ShareSDK.cancelAuthorize(plaformType) { error in
//            callback(true,["error":error as Any], plaformType)
//        }
//    }
//    
//    func share(_ platformType:SSDKPlatformType, text:String, images:Any?, url:NSURL?, title: String, type: SSDKContentType, callback:@escaping ShareCallBlock) {
//        
//        var textStr = text
//        var titleStr = title
//        var tUrl = url
//        
//        //QQ 100
//        if platformType == .typeWechat || platformType == .subTypeWechatTimeline {
//            if text.kLenght > 200 {
//                textStr = textStr.sub(to: 200)
//            }
//            if titleStr.kLenght > 100 {
//                titleStr = titleStr.sub(to: 200)
//            }
//        } else if platformType == .typeTwitter {
//            if textStr.kLenght > 140 {
//                textStr = textStr.sub(to: 140)
//            }
//        }
//        
//        //line whatsapp 只支持文字不支持链接 分享
//        if (platformType == .typeLine || platformType == .typeWhatsApp) && tUrl != nil {
//            textStr = "\(textStr) \n\(tUrl?.absoluteString ?? "")"
//            tUrl = nil
//        }
//        
//        //telegram 只支持纯图片 或 链接
//        if platformType == .typeTelegram {
//            textStr = ""
//            titleStr = ""
//        }
//        
//        var parameters = NSMutableDictionary()
//        if platformType == .typeFacebook {
//            if url == nil || url?.absoluteString == nil || url?.absoluteString?.length == 0 {
//                parameters.ssdkSetupShareParams(byText: textStr, images: images, url: url as URL?, title: titleStr, type: type)
//            } else {
//                parameters.ssdkSetupFacebookParams(byText: textStr, image: images, url: url as URL?, urlTitle: titleStr, urlName: nil, attachementUrl: nil, hashtag: nil, quote: nil, shareType: .native, type: .webPage)
//            }
//        } else if platformType == .typeWechat {
//            
////            parameters.ssdkSetupWeChatParams(byText: <#T##String!#>, title: <#T##String!#>, url: <#T##URL!#>, thumbImage: <#T##Any!#>, image: <#T##Any!#>, musicFileURL: <#T##URL!#>, extInfo: <#T##String!#>, fileData: <#T##Any!#>, emoticonData: <#T##Any!#>, sourceFileExtension: <#T##String!#>, sourceFileData: <#T##Any!#>, type: <#T##SSDKContentType#>, forPlatformSubType: <#T##SSDKPlatformType#>)
//        } else if platformType == .typeSinaWeibo {
//            
////            parameters.ssdkSetupSinaWeiboShareParams(byText: <#T##String!#>, title: <#T##String!#>, images: <#T##Any!#>, video: <#T##String!#>, url: <#T##URL!#>, latitude: <#T##Double#>, longitude: <#T##Double#>, objectID: <#T##String!#>, isShareToStory: <#T##Bool#>, type: <#T##SSDKContentType#>)
//        }
//        else {
//            //通用参数（如果不行，可以用对应平台的）
//            parameters.ssdkSetupShareParams(byText: textStr, images: images, url: url as URL?, title: titleStr, type: type)
//        }
//        
//        self.share(platformType: platformType, paramaters: parameters, callback: callback)
//    }
//    
//    //自定义分享 无UI
//    private func share(platformType:SSDKPlatformType, paramaters:NSMutableDictionary, callback: @escaping ShareCallBlock) {
//        ShareSDK.share(platformType, parameters: paramaters) { state, userData, contentEntity, error in
//            switch state {
//            case .success:
//                callback(true,userData as? [String: Any] ?? [:], platformType)
//                break
//            case .fail:
//                if (platformType == .typeFacebook || platformType == .typeUnknown) && error != nil {
//                    if let nsError = error as NSError? {
//                        let userInfo = nsError.userInfo
//                        print("share error: \(userInfo)")
//                        callback(false, ["error":error ?? ""], platformType)
//                    } else {
//                        callback(false, ["error":error ?? ""], platformType)
//                    }
//                } else {
//                    callback(false, ["error":error ?? ""], platformType)
//                }
//                break
//            case .cancel:
//                callback(false,[:],platformType)
//                break
//            default:
//                callback(false,nil,platformType)
//                break
//            }
//        }
//    }
}
