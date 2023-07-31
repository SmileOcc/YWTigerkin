//
//  YXLoginTitleView.swift
//  YWTigerkin
//
//  Created by odd on 7/22/23.
//

import UIKit

class YXLoginTitleView: UIView {

    typealias TitleChanage = (String)->()
    
    var didChanage:TitleChanage?
    
    lazy var mainLabel:UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = .fscMedium(24)
        label.textAlignment = .left
        label.textColor = YWThemesColors.col_8A2BE2
        return label
    }()
    
    lazy var subButton :UIButton = {
        let btn = UIButton.init(frame: .zero)
        btn.setTitleColor(YWThemesColors.col_8A2BE2.withAlphaComponent(0.5), for: .normal)
        btn.titleLabel?.font = .fscRegular(14)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(exchanage), for: .touchUpInside)
        return btn
    }()
    
    lazy var arrowImgView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.image = YWThemesColors.col_themeImage(UIImage(named: "arrow_right_gray"))
        view.alpha = 0.5
        return view
    }()
    
    var mainTitle = ""
    var subTittle = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(mainTitle:String,subTitle:String) {
        self.init(frame: .zero)
        self.mainTitle = mainTitle
        self.subTittle = subTitle
        setupUI()
    }
    
   
    func setupUI(){
        addSubview(mainLabel)
        addSubview(arrowImgView)
        addSubview(subButton)
        
        mainLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(29)
        };
        
        subButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(19)
            make.top.equalTo(mainLabel.snp_bottomMargin).offset(12)
        }
        
        arrowImgView.snp.makeConstraints { make in
            make.centerY.equalTo(subButton.snp.centerY)
            make.left.equalTo(subButton.snp.right).offset(-4)
        }
        
        refreshTitle()
    }
    
    func refreshTitle() {
        mainLabel.text = mainTitle
        subButton.setTitle(subTittle, for: .normal)
    }
    
    @objc func exchanage(){
        let tmp = mainTitle
        mainTitle = subTittle
        subTittle = tmp
        refreshTitle()
        didChanage?(mainTitle)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

