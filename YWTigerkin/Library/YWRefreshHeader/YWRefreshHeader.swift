//
//  YWRefreshHeader.swift
//  YWTigerkin
//
//  Created by odd on 3/22/23.
//

import Foundation
import YYImage
import UIKit

enum YWRefreshState: Int {
    
    //松开就可以进行刷新的状态
    case bannerPulling = 10
    //Banner即将刷新的状态
    case bannerWillRefresh
    //触发 下拉banner
    case bannerDropTriggered
    //显示 下拉banner,类似淘宝二楼效果
    case bannerDropShowing
}
class YWRefreshHeader: MJRefreshNormalHeader {

    var dropBannerBlock:(()->Void)?
    ///正在下拉触发的block
    var dropPullingBlock:(()->Void)?
    ///下拉显示的转圈logo的偏移量
    var startViewOffsetY:CGFloat = 0.0
    
    var bannerModel:YWAdvsEventsModel? {
        didSet {
            if let model = bannerModel {
                self.hideTitle = kIsEmpty(model.imageUrl)
                
                if !self.scrollView.showDropBanner || kIsEmpty(model.imageUrl) {
                    self.bannerView.removeFromSuperview()
                    
                    self.tipLabel.attributedText = nil
                    self.tipLabel.font = UIFont.systemFont(ofSize: 12)
                    self.tipLabel.textColor = YWThemesColors.col_999999
                    self.tipLabel.text = "show out...."
                    self.tipLabel.textAlignment = .center
                    return
                }
                
                self.addSubview(self.bannerView)
                self.sendSubviewToBack(self.bannerView)
                self.bannerView.yy_setHighlightedImage(with: URL(string: model.imageUrl ?? ""), placeholder: UIImage(named: "index_banner_loading"), options: .setImageWithFadeAnimation, completion: nil)
                
                if let width = model.banner_width, width.toFloat() > 0 {
                    let bannerH: CGFloat = CGFloat(model.banner_heigth?.toFloat() ?? 0.0)
                    let bannerW: CGFloat = CGFloat(model.banner_width?.toFloat() ?? 0.0)
                    
                    self.bannerView.snp.makeConstraints { make in
                        make.left.right.bottom.equalToSuperview()
                        make.height.equalTo(bannerH * YWConstant.screenWidth / bannerW)
                    }
                }
                
                self.mj_h = 66
                self.layoutIfNeeded()
            }
        }
    }
    
    func queryTitleAttribute(_ title: String) -> NSMutableAttributedString {
        let titleAttribute = NSMutableAttributedString(string: title)
        titleAttribute.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(location: 0, length: title.count))
        
//        titleAttribute.setValue(UIFont.systemFont(ofSize: 12), forKey: NSAttributedString.Key.font.rawValue)
//        titleAttribute.setValue(UIColor.white, forKey: NSAttributedString.Key.foregroundColor.rawValue)
//        titleAttribute.yy_alignment = .center
        return titleAttribute
    }
    
    lazy var tipLabel:UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.textAlignment = .center
        return view
    }()
    lazy var bannerView: YYAnimatedImageView = {
        let view = YYAnimatedImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    var hideTitle: Bool = false
    
    var isShowTip:Bool? {
        didSet {
            self.addSubview(self.tipLabel)
            self.tipLabel.snp.makeConstraints { make in
                make.bottom.equalTo(-15)
                make.centerX.equalTo(self)
                make.height.equalTo(12)
                make.width.lessThanOrEqualToSuperview()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare() {
        super.prepare()
        
        self.backgroundColor = UIColor.clear
        self.startViewOffsetY = 5.0
        self.mj_h = 66.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: NSNotification.Name(rawValue: UIApplication.didBecomeActiveNotification.rawValue), object: nil)
    }
    
    //MARK: 设置子控件的位置和尺寸
    override func placeSubviews() {
        super.placeSubviews()
        if self.startViewOffsetY == 0.0 {
            self.startViewOffsetY = 5.0
        }
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        
        var offsetY = self.scrollView.mj_offsetY
        var dropBannerOffsetY = -90.0
        
        if self.scrollView.showDropBanner {
            if self.scrollView.isDragging {
//                if self.state == .pulling && offsetY < dropBannerOffsetY {
//                    print("触发下拉banner")
//                    //self.state = .bannerDropTriggered
//                }
//                else if self.state == .bbannerDropTriggered && offsetY >= dropBannerOffsetY {
//                    self.state = .Stride
//                }
            } else {
//                if self.state == .bannerDropTriggered {
//                    self.state = .bannerDropShowing
//                } else if self.state == .bannerDropShowing{
//                    self.state = .Stride
//                }
            }
        }
        
        super.scrollViewContentOffsetDidChange(change)
    }
    
    override var state: MJRefreshState {
        didSet {
            if state  == oldValue {
                return;
            }
            super.state = state
            
            var attribute:NSMutableAttributedString?
            
            switch state {
            case .idle:
                if self.hideTitle == false {
                    attribute = self.queryTitleAttribute("refresh pull down")
                    self.tipLabel.attributedText = attribute
                }
                break
            case .pulling:
                if self.hideTitle == false {
                    attribute = self.queryTitleAttribute("refresh pull down")
                    self.tipLabel.attributedText = attribute
                }
                self.dropPullingBlock?()
                break
            case .refreshing:
                if self.hideTitle == false {
                    attribute = self.queryTitleAttribute("refresh loading")
                    self.tipLabel.attributedText = attribute
                }
                break
            case .willRefresh:
                if self.hideTitle == false {
                    attribute = self.queryTitleAttribute("refresh release")
                    self.tipLabel.attributedText = attribute
                }
                break
            default:
                break
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            super.pullingPercent = pullingPercent
            if self.state != .idle {
                return
            }
        }
    }
    
    @objc func appDidBecomeActive() {
        
    }
}
