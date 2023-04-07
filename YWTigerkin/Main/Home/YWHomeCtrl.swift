//
//  YWHomeCtrl.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit
import Then

class YWHomeCtrl: YWBaseViewController, YWViewModelBased{
    
    var viewModel: YWHomeViewModel!
    
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
        self.title = "home"
        // Do any additional setup after loading the view.
        
        // count计算表情符号错误的，方式与oc length方式不一样，要用utf16
        print("count: \(label.text!.count)   length:\(label.text!.utf16.count)")
        
        self.view.addSubview(label)
        self.view.addSubview(inputTf)
        self.view.addSubview(self.themesMainView)
        
        self.themesMainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
