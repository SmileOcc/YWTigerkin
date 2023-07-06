//
//  YWDouYinVideoCell.swift
//  YWTigerkin
//
//  Created by odd on 7/1/23.
//

import UIKit

class YWDouYinVideoCell: UITableViewCell {

    var model:YWDouYinVideoModel? {
        didSet {
            if let tModel = model {
                
            }
        }
    }
    
    lazy var playerView: YWVideoPlayView = {
       let view = YWVideoPlayView()
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(playerView)
        playerView.backgroundColor = UIColor.random
        
        playerView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
