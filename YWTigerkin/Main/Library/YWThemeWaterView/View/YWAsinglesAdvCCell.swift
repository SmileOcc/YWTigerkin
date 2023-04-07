//
//  YWAsinglesAdvCCell.swift
//  YWTigerkin
//
//  Created by odd on 4/2/23.
//

import UIKit

@objc protocol YWAsinglesAdvCCellDelegate:NSObjectProtocol {
    @objc func yw_asingleCCell(cell: YWAsinglesAdvCCell, model:Any)
}

class YWAsinglesAdvCCell: UICollectionViewCell,YWCollectCCellProtocol {
        
    weak var delegate: YWCollectionCellDelegate?
    
    var model: YWCollectionCellModelProtocol? {
        didSet {
            if let tModel = model?.dataSource as? YWAdvsEventsModel {
                self.goodsImageView.yy_setImage(with: URL(string: tModel.imageUrl ?? ""), placeholder: nil)

            }
            if let tModel = model?.dataSource as? YWAdvEventSpecialModel {
                self.goodsImageView.yy_setImage(with: URL(string: tModel.images ?? ""), placeholder: nil)
            }
        }
    }
    
    var goodsImageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    var advModel:YWAdvEventSpecialModel? {
        didSet {
            self.goodsImageView.yy_setImage(with: URL(string: advModel?.images ?? ""), placeholder: nil)
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.random
        
        self.addSubview(self.goodsImageView)
        goodsImageView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
