//
//  YWAccountCell.swift
//  YWTigerkin
//
//  Created by odd on 3/16/23.
//

import UIKit

class YWAccountCell: UITableViewCell {

    var model:YWAccountItemModel? {
        didSet {
            self.titleLab.text = model?.title
            self.imgView.image = UIImage(named: model?.imgName ?? "")
            self.descLab.text = model?.desc
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()
    
    lazy var imgView:UIImageView = {
        let view = UIImageView.init(frame: CGRect.zero)
        return view
    }()
    
    lazy var titleLab:UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.textColor = UIColor.hexColor("0x222222")
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    lazy var descLab:UILabel = {
       let view = UILabel()
        view.textColor = UIColor.hexColor("0x999999")
        view.font = UIFont.systemFont(ofSize: 13)
        view.textAlignment = .right
        return view
    }()
    
    lazy var arrowImgView: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "account_arrow")
        return view
    }()
    lazy var lineView:UIView = {
      let view = UIView()
        view.backgroundColor = UIColor.hexColor("0xEEEEEE")
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubview(bgView)
        self.bgView.addSubview(imgView)
        self.bgView.addSubview(titleLab)
        self.bgView.addSubview(descLab)
        self.bgView.addSubview(arrowImgView)
        self.bgView.addSubview(lineView)
        
//        imgView.backgroundColor = UIColor.random
//        titleLab.backgroundColor = UIColor.random
//        descLab.backgroundColor = UIColor.random
        
        bgView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(16)
            make.right.equalTo(self.snp.right).offset(-16)
            make.top.bottom.equalTo(self)
        }
        
        imgView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(12)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
            make.centerY.equalTo(self.snp.centerY)
        }
        
        arrowImgView.snp.makeConstraints { make in
            make.right.equalTo(self.snp.right).offset(-12)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(self.imgView.snp.right).offset(4)
            make.centerY.equalTo(self.imgView.snp.centerY)
        }
        
        descLab.snp.makeConstraints { make in
            make.left.equalTo(self.titleLab.snp.right).offset(4)
            make.centerY.equalTo(self.imgView.snp.centerY)
            make.right.equalTo(self.arrowImgView.snp.left).offset(-4)
        }
        

        
        lineView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(8)
            make.right.equalTo(self.snp.right).offset(-8)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
