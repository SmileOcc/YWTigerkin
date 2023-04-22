//
//  YWNavBarBaseView.swift
//  YWTigerkin
//
//  Created by odd on 4/22/23.
//

import UIKit

class YWNavBarBaseView: UIView {

    var backBlock:(()->Void)?
    var rightBlack:(()->Void)?
    
    var title:String? {
        didSet {
            self.titleLab.text = title ?? ""
        }
    }
    
    lazy var backView:UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage.init(named: "nav_back"), for: .normal)
        view.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
        view.contentHorizontalAlignment = .left
        return view
    }()
    
    lazy var rightView:UIButton = {
        let view = UIButton(type: .custom)
        view.addTarget(self, action: #selector(actionRight), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    lazy var titleView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var titleLab:UILabel = {
        let view = UILabel()
        view.font = UIFont.boldFont(14)
        view.textAlignment = .center
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleView)
        self.addSubview(backView)
        self.addSubview(rightView)
        self.addSubview(titleLab)
        
        titleView.snp.makeConstraints { make in
            make.left.equalTo(backView.snp.right).offset(8)
            make.right.equalTo(rightView.snp.left).offset(-8)
            make.bottom.equalTo(self.snp.bottom)
            make.top.equalTo(self.snp.top).offset(YWConstant.statusBarHeight)
        }
        
        backView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(16)
            make.centerY.equalTo(self.titleView.snp.centerY)
            make.width.equalTo(44)
        }
        
        rightView.snp.makeConstraints { make in
            make.right.equalTo(self.snp.right).offset(-16)
            make.centerY.equalTo(self.titleView)
            make.width.equalTo(44)
        }
        
        titleLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleView.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func actionBack() {
        self.backBlock?()
    }
    
    @objc func actionRight() {
        self.rightBlack?()
    }
    
}
