//
//  YWAddressItemEditCell.swift
//  YWTigerkin
//
//  Created by odd on 11/27/23.
//

import UIKit

class YWAddressItemEditCell: YWAddressItemBaseCell {

    var didchangeBlock:((YWAddressItemBaseCell,YWAddressItemEditModel)->Void)?
    var model:YWAddressItemEditModel? {
        didSet {
            if let tmodel = model {
                self.textField.text = tmodel.content
//                self.setNeedsUpdateConstraints()
//                self.updateConstraintsIfNeeded()
                
////                self.textField.sizeToFit()
//
//                let theight = self.textField.frame.size.height
//                if theight > 40 {
//                    tmodel.contentH = theight + 16.0
//                } else {
//                    tmodel.contentH = 56.0
//                }
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = .random
        
        self.contentView.addSubview(self.textField)
        self.textField.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(self.snp.top).offset(8)
            make.bottom.equalTo(self.snp.bottom).offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textField:UITextView = {
        let view = Init(UITextView()) {
            $0.textColor = YWThemesColors.col_0D0D0D
            $0.backgroundColor = .random
            //$0.isScrollEnabled = false
        }
        view.delegate = self
        return view
    }()
    
    
    static func contentHeight(str:String) -> CGFloat {
        let view = Init(UITextView()) {
            $0.size = CGSize(width: YWConstant.screenWidth - 32.0, height: 1000.0)
            $0.textColor = YWThemesColors.col_0D0D0D
            $0.backgroundColor = .random
            //$0.isScrollEnabled = false
        }
        
        view.text = str
        view.sizeToFit()
        let th = view.frame.size.height
        if th > 40 {
            return th + 16.0
        }
        
        return 40.0 + 16.0
    }
}


extension YWAddressItemEditCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if let tmodel = self.model {
            tmodel.content = textView.text
            
            self.textField.sizeToFit()
            
            let theight = self.textField.frame.size.height
            if theight > 40 {
                tmodel.contentH = theight + 16.0
            } else {
                tmodel.contentH = 56.0
            }
            self.didchangeBlock?(self,tmodel)
        }
    }
}
