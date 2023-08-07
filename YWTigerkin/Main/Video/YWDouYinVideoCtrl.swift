//
//  YWDouYinVideoCtrl.swift
//  YWTigerkin
//
//  Created by odd on 7/1/23.
//

import UIKit

class YWDouYinVideoCtrl: YWBaseViewController , HUDViewModelBased {
    
    var viewModel: YWDouYinVideoViewModel!
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    lazy var backView:UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage.init(named: "nav_back")?.withTintColor(.white), for: .normal)
        view.addTarget(self, action: #selector(goBackAction), for: .touchUpInside)
        view.contentHorizontalAlignment = .left
        return view
    }()
    
    @objc dynamic var currentIndex:Int = 0
    
    var isCurPlayerPause:Bool = false
    var pageIndex:Int = 0
    var pageSize:Int = 21
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoTable.layer.removeAllAnimations()
        let cells = videoTable.visibleCells as! [AwemeListCell]
        for cell in cells {
            cell.playerView.cancelLoading()
        }
        NotificationCenter.default.removeObserver(self)
        self.removeObserver(self, forKeyPath: "currentIndex")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sh_prefersNavigationBarHidden = true
        self.sh_interactivePopDisabled = true
        
        self.videoTable.automaticallyAdjustsScrollIndicatorInsets = false
        
        self.createView()
        
        bindViewModel()
        viewModelResponse()
        bindHUD()
        
        self.viewModel.loadData(isMore: false)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            self.view.addSubview(self.videoTable)
            //self.data = self.awemes
            self.videoTable.reloadData()
            
            let curIndexPath = IndexPath.init(row: self.currentIndex, section: 0)
            self.videoTable.scrollToRow(at: curIndexPath, at: UITableView.ScrollPosition.top, animated: false)
            self.addObserver(self, forKeyPath: "currentIndex", options: [.initial, .new], context: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarTouchBegin), name: NSNotification.Name(rawValue: StatusBarTouchBeginNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func createView() {
        
        self.view.addSubview(self.videoTable)
        self.view.addSubview(self.backView)
        
        backView.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(16)
            make.top.equalTo(self.view.snp.top).offset(YWConstant.isIphoneX() ? 50 : 40)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        self.videoTable.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset(-YWConstant.screenHeight)
        }
        
        
    }
    
    override func bindViewModel() {
        
    }
    
    override func viewModelResponse() {
//        viewModel.resultSubject.subscribe(onNext: {[weak self] (success) in
//            guard let `self` = self else {return}
//
//        }).disposed(by: disposeBag)
    }

    
    lazy var videoTable: UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: -YWConstant.screenHeight, width: YWConstant.screenWidth, height: YWConstant.screenHeight * 3.0), style: .plain)
        view.contentInset = UIEdgeInsets(top: YWConstant.screenHeight, left: 0, bottom: YWConstant.screenHeight * 1.0, right: 0);
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        
        view.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        
//        view.register(YWDouYinVideoCell.self, forCellReuseIdentifier: NSStringFromClass(YWDouYinVideoCell.self))
        
        view.register(AwemeListCell.self, forCellReuseIdentifier: NSStringFromClass(AwemeListCell.self))

        return view
    }()

}

extension YWDouYinVideoCtrl: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AwemeListCell.self), for: indexPath) as! AwemeListCell
        if self.viewModel.datas.count > indexPath.row {
            let model = self.viewModel.datas[indexPath.row]
//            cell.model = model
            cell.initData(aweme: model)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        YWConstant.screenHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.001
    }
    
    func goOtherAction() {
        let otherViewModel = YWOtherTestViewModel()
        let context = YWNavigatable(viewModel: otherViewModel)

        self.viewModel.navigator.pushPath(YWModulePaths.settingOther.url, context: context, animated: true)
    }
    
}


extension YWDouYinVideoCtrl:UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            if translatedPoint.y < -50 && self.currentIndex < (self.viewModel.datas.count - 1) {
                self.currentIndex += 1
            }
            if translatedPoint.y > 50 && self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.videoTable.scrollToRow(at: IndexPath.init(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
}

extension YWDouYinVideoCtrl {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "currentIndex") {
            isCurPlayerPause = false
            weak var cell = videoTable.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as? AwemeListCell
            if cell?.isPlayerReady ?? false {
                cell?.replay()
            } else {
                AVPlayerManager.shared().pauseAll()
                cell?.onPlayerReady = {[weak self] in
                    if let indexPath = self?.videoTable.indexPath(for: cell!) {
                        if !(self?.isCurPlayerPause ?? true) && indexPath.row == self?.currentIndex {
                            cell?.play()
                        }
                    }
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc func statusBarTouchBegin() {
        currentIndex = 0
    }
    
    @objc func applicationBecomeActive() {
        let cell = videoTable.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as! AwemeListCell
        if !isCurPlayerPause {
            cell.playerView.play()
        }
    }
    
    @objc func applicationEnterBackground() {
        let cell = videoTable.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as! AwemeListCell
        isCurPlayerPause = cell.playerView.rate() == 0 ? true :false
        cell.playerView.pause()
    }
}

