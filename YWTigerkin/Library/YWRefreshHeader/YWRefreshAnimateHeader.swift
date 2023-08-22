//
//  YWRefreshAnimateHeader.swift
//  YWTigerkin
//
//  Created by odd on 8/22/23.
//

import UIKit

class YWRefreshAnimateHeader: MJRefreshHeader {

    @objc var xNoNavStyle = false
    
    private var refreshingStartTime  : TimeInterval = 0

    
    lazy var pullingView : YWLottieView = {
        let pullingView = YWLottieView(frame: .zero, name: refreshAnimation())
        return pullingView
      }()
    
    
    lazy var refreshingView: YWLottieView = {
        let refreshingView = YWLottieView(frame: .zero, name: refreshAnimation())
        refreshingView.lottieView.loopMode = .loop
        return refreshingView
    }()
    
    
    lazy var tiplab: UILabel = {
        let label = UILabel()
        label.textColor = self.tipLabelColor()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    func pullingAnimation() -> String {
        "refresh_pulling"
    }
    
    func refreshAnimation() -> String {
        "animation_02"
    }
    
    func tipLabelColor() -> UIColor {
        YWThemesColors.col_themeColor_03
    }

    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                self.pullingView.stop()
                self.refreshingView.isHidden = true
                self.pullingView.isHidden = false
                self.tiplab.text = YWLanguageTool("MJRefreshHeaderIdleText")
                self.refreshingView.stop()
            case .pulling:
                self.refreshingView.isHidden = true
                self.pullingView.isHidden = false
                self.tiplab.text = YWLanguageTool("MJRefreshHeaderPullingText")
            case .refreshing:
                self.refreshingView.play()
                self.refreshingView.isHidden = false
                self.pullingView.isHidden = true
                self.pullingView.play(progress: 1.0)
                self.tiplab.text = YWLanguageTool("MJRefreshHeaderRefreshingText")
                self.refreshingStartTime = Date.timeIntervalSinceReferenceDate
            case .noMoreData:
                YWLog("noMoreData")
            case .willRefresh:
                YWLog("willRefresh")
            default:
                YWLog("unkonw - refresh")
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            if state != .idle {
                return
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        
        self.mj_h = 95
        self.addSubview(self.pullingView)
        self.addSubview(self.refreshingView)
        self.addSubview(self.tiplab)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        var y = self.mj_h-60
        if xNoNavStyle {
            y = self.mj_h-75
        }
        
        self.pullingView.bounds = CGRect.init(x: 0, y: 0, width: uniHorLength(68), height: 68)
        self.pullingView.center = CGPoint.init(x: self.mj_w/2, y: y)
        self.refreshingView.bounds = CGRect.init(x: 0, y: 0, width: uniHorLength(68), height: 68)
        self.refreshingView.center = CGPoint.init(x: self.mj_w/2, y: y)
        self.tiplab.bounds = CGRect.init(x: 0, y: 0, width: YWConstant.screenWidth, height: 25)
        self.tiplab.center = CGPoint(x: self.mj_w/2, y: self.pullingView.frame.minY+self.pullingView.frame.height+10)
    }
    
    override func endRefreshing() {
        
        let diff = Date.timeIntervalSinceReferenceDate - self.refreshingStartTime
        
        if  diff >= 1 {
            self.delayEndRefreshing()
        }else {//完成一次动画播放耗时1秒
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (1 - diff)) {
                self.delayEndRefreshing()
            }
        }
        
    }
    //为了展示刷新完成状态延迟 刷新
    private func delayEndRefreshing() {
        self.refreshingView.isHidden = true
        self.pullingView.isHidden = false
      //  pullingView.image = refreshDoneImage
        self.tiplab.text = YWLanguageTool("MJRefreshHeaderRefreshDoneText")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            super.endRefreshing()
        }
    }
}
