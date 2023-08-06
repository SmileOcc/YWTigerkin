//
//  YWAdvertiseBaseView.swift
//  YWTigerkin
//
//  Created by odd on 8/5/23.
//

import UIKit
import RxSwift
import RxCocoa
import URLNavigator

class YWAdvertiseBaseView: UIView {

    let disposeBag = DisposeBag()
    var timeCount = 5
    let timerMark = "registerCode"
    //回调 关闭
    var callBack: (() -> Void)!
    
    
    lazy var jumpBtn: UIButton = {
        let text = YWLanguageUtility.kLang(key: "lanuch_Skip") + " 3"
        let btn = UIButton()
        btn.setTitle(text, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setBackgroundImage(UIImage.init(named: "icon_skip"), for: .normal)
        return btn
    }()

    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        self.backgroundColor = YWThemesColors.col_themeColor.withAlphaComponent(0.3)
        
        let screenHeight = YWConstant.screenHeight
        //广告图片
        let advertiseImgView = UIImageView(image: image)
        advertiseImgView.contentMode = .scaleAspectFill
        advertiseImgView.frame = CGRect(x: 0, y: 0, width: YWConstant.screenWidth, height: screenHeight)
        advertiseImgView.clipsToBounds = true
        self.addSubview(advertiseImgView)
        //点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(advertiseGesture))
        advertiseImgView.addGestureRecognizer(tap)
        advertiseImgView.isUserInteractionEnabled = true
        
        //底部的logo图片
        let advertiseImage = getImage(name: "")
        let logoImgView = UIImageView(image: advertiseImage)
        logoImgView.contentMode = .scaleAspectFit
        self.addSubview(logoImgView)
        let advertiseWidth:CGFloat = 130.0
        
//        let advertiseHeight = advertiseWidth / advertiseImage.size.width * advertiseImage.size.height
        
        let advertiseHeight = 20.0
        let advertiseTop = screenHeight * 7.0 / 32 / 2.0 - advertiseHeight
        logoImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(advertiseImgView.snp.bottom).offset(advertiseTop)
            make.size.equalTo(CGSize(width: advertiseWidth, height: advertiseHeight))
        }
        
        
        self.addSubview(jumpBtn)
        jumpBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(YWConstant.statusBarHeight + 14)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(26)
        }
        jumpBtn.rx.tap.bind { [weak self] in
            YWTTimer.shared.cancleTimer(WithTimerName: self?.timerMark)
            self?.callBack()
            }.disposed(by: disposeBag)
        
        self.startTimer()
        
        let icon = UIImageView.init(image: UIImage.init(named: "icon_banner_tag"))
        self.addSubview(icon)
        let bottomLabel = UILabel()
        bottomLabel.text = "2023 TigerKin"
        bottomLabel.textColor = YWThemesColors.col_8A2BE2
        bottomLabel.font = .systemFont(ofSize: 14)
        self.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImgView.snp.bottom).offset(4)
            make.height.equalTo(16)
            make.centerX.equalTo(logoImgView).offset(4)
        }
        
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(bottomLabel)
            make.right.equalTo(bottomLabel.snp.left).offset(-4)
        }
        //先隐藏底部图标
        logoImgView.isHidden = true
        bottomLabel.isHidden = true
        icon.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func advertiseGesture() {
        let data = MMKV.default()?.data(forKey: YWUserManager.YWSplashScreenAdvertisementShowing)
        do {
            let first = try JSONDecoder().decode(SplashscreenList.self, from: data ?? Data())
                if first.jumpURL?.count ?? 0 <= 0 {
                    return
                }
                let banner = BannerList(bannerID: first.bannerID,
                                        adType: first.adType,
                                        adPos: first.adPos,
                                        pictureURL: first.pictureURL,
                                        originJumpURL: first.jumpURL,
                                        newsID: String(describing: first.bannerID),
                                        bannerTitle: "",
                                        tag: "0",
                                        jumpType: ""
                                       )
            let advModel = YWAdvsEventsManager.parseAdvsEventsModel(banner.jumpURL ?? "")
            YWAdvsEventsManager.advEventTarget(target: nil, advEventModel: advModel)
                self.callBack()
        } catch {
            
        }
    }
    
    func startTimer() {
        
        timeCount = 3
        YWTTimer.shared.cancleTimer(WithTimerName: self.timerMark)
        YWTTimer.shared.scheduledDispatchTimer(WithTimerName: self.timerMark, timeInterval: 1, queue: .main, repeats: true) { [weak self] in
            self?.timerAction()
        }
    }
    
    @objc func timerAction() {
        if timeCount >= 0 {
            jumpBtn.setTitle( String(format: "%@ %ld", YWLanguageUtility.kLang(key: "lanuch_Skip"),timeCount), for: .normal)
            timeCount -= 1
        }else {
            YWTTimer.shared.cancleTimer(WithTimerName: timerMark)
            self.callBack()
        }
    }

}
