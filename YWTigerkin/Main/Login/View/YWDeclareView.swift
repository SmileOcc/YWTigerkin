//
//  YWDeclareView.swift
//  YWTigerkin
//
//  Created by odd on 7/26/23.
//

import UIKit

class YWDeclareView: UIView {

    typealias ClickService = ()->()
    typealias ClickPrivacy = ()->()
    
    var didClickService : ClickService?
    var didClickPrivacy: ClickService?
    
   
    lazy var privacyLable : YYLabel = {
        let label = YYLabel()
        let text = YWLanguageUtility.kLang(key: "login_privacy_tips")
        let attrString = NSMutableAttributedString(string: text)
        attrString.yy_font = UIFont.systemFont(ofSize: 12)
        attrString.yy_lineSpacing = 2
        attrString.yy_color = YWThemesColors.col_themeColor
        attrString.yy_lineBreakMode = .byWordWrapping
        if let linkRange = text.range(of: YWLanguageUtility.kLang(key: "login_privacy_tip_link_key_words_1")) {
            let nsRange = NSRange.init(linkRange, in: text)
            attrString.yy_setTextHighlight(nsRange, color: YWThemesColors.col_8A2BE2, backgroundColor: nil) { [weak self] (containerView, text, range, rect) in
                guard let `self` = self else { return }
                self.didClickService?()
            }
        }
        
        if let linkRange = text.range(of: YWLanguageUtility.kLang(key: "login_privacy_tip_link_key_words_2")) {
            let nsRange = NSRange.init(linkRange, in: text)
            attrString.yy_setTextHighlight(nsRange, color: YWThemesColors.col_8A2BE2, backgroundColor: nil) { [weak self] (containerView, text, range, rect) in
                guard let `self` = self else { return }
                self.didClickPrivacy?()
            }
        }
        attrString.yy_alignment = .center
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = YWConstant.screenWidth - CGFloat(70)
        label.attributedText = attrString
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(privacyLable)
        
        privacyLable.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
     }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
