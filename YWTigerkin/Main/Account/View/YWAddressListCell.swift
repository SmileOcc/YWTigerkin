//
//  YWAddressListCell.swift
//  YWTigerkin
//
//  Created by odd on 11/27/23.
//

import UIKit

class YWAddressListCell: UITableViewCell {

    var model:YWAddressModel? {
        didSet {
            if let tmodel = model {
                
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = .random
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
