//
//  YWHomeCtrl.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit
import Then

class YWHomeCtrl: YWBaseViewController, HUDViewModelBased{
    
    var viewModel: YWHomeViewModel!
    
    var networkingHUD: YWProgressHUD! = YWProgressHUD()

    //是否触发过请求
    var hasCheckPop = false
    lazy var topBar:YWHomeNavBar = {
        let view = YWHomeNavBar(frame: CGRect.zero)
        view.showBottomLine(false)
        
        view.clickBlock = {[weak self] (type,str) in
            guard let `self` = self else {return}
            switch type {
            case .search:
                let searchModel = YWSearchViewModel()
                let context = YWNavigatable(viewModel: searchModel)
                self.viewModel.navigator.pushPath(YWModulePaths.search.url, context: context, animated: true)
            case .message:
                let messageModel = YWMessageViewModel()
                let context = YWNavigatable(viewModel: messageModel)
                self.viewModel.navigator.pushPath(YWModulePaths.messageCenter.url, context: context, animated: true)
                
            case .cart:
                let cartModel = YWCartViewModel()
                let context = YWNavigatable(viewModel: cartModel)
                self.viewModel.navigator.pushPath(YWModulePaths.cart.url, context: context, animated: true)
            default:
                YWLog("未知")
            }
            
        }
        return view
    }()

    lazy var themesMainView: YWThemesMainView = {
        let view = YWThemesMainView(frame: self.view.bounds, firstChannel: "", channelId: "", title: "")
        view.backgroundColor = UIColor.random
        return view
    }()

    let label = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "Hello, World!"
        $0.backgroundColor = UIColor.random
    }
    
    lazy var inputTf: UITextField = {
        let view = UITextField(frame: CGRect.zero)
        view.backgroundColor = UIColor.random
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        sh_prefersNavigationBarHidden = true
        
        self.bindHUD()
        #if DEV
        //self.title = "home-dev"
        #elseif PRD
        //self.title = "home-prd"
        #else
        
        #endif

        #if TEST_SIT
        
        #elseif TEST_DEV
        
        #endif
        // Do any additional setup after loading the view.
        
        // count计算表情符号错误的，方式与oc length方式不一样，要用utf16
        print("count: \(label.text!.count)   length:\(label.text!.utf16.count)")
        
        self.label.isHidden = true
        self.inputTf.isHidden = true
        
        self.view.addSubview(label)
        self.view.addSubview(topBar)
        self.view.addSubview(inputTf)
        self.view.addSubview(self.themesMainView)
        
        
        
        self.themesMainView.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.snp_bottomMargin)
        }
        
        self.themesMainView.viewDidShow()
        self.themesMainView.addListViewRefresh()
    
        
        label.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(16)
            make.top.equalTo(self.view.snp.top).offset(12)
            make.height.equalTo(44)
        }
        
        inputTf.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(16)
            make.top.equalTo(self.label.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 150, height: 40))
        }
        
        _ = inputTf.rx.text.skip(1)
            .subscribe(onNext: { (text) in
            print("输入：\(text)")
        })
        
        let arr = ["a","3","c"]
        let range = 0...arr.count - 1
        for i in range.reversed() {
            print("kkk: \(i)")// 2 1 0
        }
        
        YWAdvsEventsManager.parseDeeplinkDic("ywtigerkin://action?actiontype=1&url=1&name=woment&source=deeplink")
        
//        let advModel = YWAdvsEventsManager.parseAdvsEventsModel("ywtigerkin://action?actiontype=5&url=5&name=woment&source=deeplink")
//        YWLog(advModel.name)
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
//            YWAdvsEventsManager.instant.advEventTarget(target: self, advEventModel: advModel)
//        })
    }
    
    func textReplace() {
        
        // 若model是Codable，需要替换，在栈上，
        var list:[YWTestModel] = []
        for i in 0...4 {
            let model = YWTestModel()
            model.id = "\(i)"
        }
        
        let sourceModel = YWTestModel()
        sourceModel.id = "2"
        if let index = list.firstIndex(where: { info in
            print("-----------1")
            if info.id == sourceModel.id {
                return true
            }
            return false
        }) {
            
            list.replaceSubrange(index...index, with: [sourceModel])
        }
        
        //如果： itemModel是 Codable 这里是修改没作用的
        list.forEach { itemMode in
            if itemMode.id == sourceModel.id {
                itemMode.isSelect = sourceModel.isSelect
            }
        }
    }
    
    /// 请求pop弹窗
    func checkPopAlertView() {
        YWUpdateManager.shared.rx.observe(Bool.self, "finishedUpdatePop").subscribe(onNext: { [weak self] (finishedUpdatePop) in
            guard let `self` = self else { return }
            
            if finishedUpdatePop ?? false && self.hasCheckPop == false {
                self.hasCheckPop = true
                //YWPopManager.shared.checkPop(with: YWPopManager.showPageMarket, vc:self)
            }
        }).disposed(by: disposeBag)
    }

    override func refreshLoginInfoAction() {
        super.refreshLoginInfoAction()
        
        YWLog("刷新登录数据")
    }

}
