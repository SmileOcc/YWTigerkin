//
//  YWLoginAdvView.swift
//  YWTigerkin
//
//  Created by odd on 7/28/23.
//

import UIKit

class YWLoginAdvView: UIView {

    typealias closeBlock = ()->()
    typealias bannerBlock = (Int)->()
    
    @objc var didCloseBlock : closeBlock?
    @objc var tapBannerBlock: bannerBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){

     }
    
    @objc var imageURLStringsGroup = [String]() {
        didSet {
            
        }
    }
    
    @objc var numberOfPages = 0 {
        didSet {
            
        }
    }
    
    
    
    lazy var closeBannerButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(closeBannerAction), for: .touchUpInside)
        button.setImage(UIImage.init(named: "closed_white"), for: .normal)
        return button
    }()

    @objc func closeBannerAction() {
        if let close = self.didCloseBlock {
            close()
        }
    }

}
