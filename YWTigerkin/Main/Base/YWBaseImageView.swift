//
//  YWBaseImageView.swift
//  YWTigerkin
//
//  Created by odd on 7/2/23.
//

import UIKit
import YYWebImage

class YWBaseImageView: UIView {

    func test() {
        let img = UIImageView()
//        img.yy_setImage(with: <#T##URL?#>, placeholder: <#T##UIImage?#>, options: <#T##YYWebImageOptions#>, completion: <#T##YYWebImageCompletionBlock?##YYWebImageCompletionBlock?##(UIImage?, URL, YYWebImageFromType, YYWebImageStage, Error?) -> Void#>)
    }

    lazy var placeholderImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "pic_placeholder_90")
        view.isHidden = true
        return view
    }()
    
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var imageModel:ContentMode? {
        didSet {
            if let imgMod = imageModel {
                imgView.contentMode = imgMod
            }
        }
    }
    
    init(frame: CGRect, padding:Float = 0, placeholder:UIImage?, bgColor: UIColor?) {
        super.init(frame: frame)
        
        self.backgroundColor = bgColor ?? UIColor.white
        self.addSubview(imgView)
        self.addSubview(placeholderImage)
        
        imgView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(padding)
            make.top.equalTo(self.snp.top).offset(padding)
            make.right.equalTo(self.snp.right).offset(-padding)
            make.bottom.equalTo(self.snp.bottom).offset(-padding)
        }
        
        placeholderImage.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func yw_setImage(url:URL?, placeholder: UIImage?, options:YYWebImageOptions, completion:YYWebImageCompletionBlock?) {
        
        if let tPlacdholderImag = placeholder {
            self.placeholderImage.image = tPlacdholderImag
            self.placeholderImage.isHidden = false
        } else {
            self.placeholderImage.isHidden = true
        }
        //这里也可以进行判断是否可以打开，URL中文编码处理
        if let tUrl = url {
            imgView.yy_setImage(with: tUrl, placeholder: nil, options: options) {[weak self] (img, url, type, imageStage, error) in
                guard let self = `self` else {return}
                
                if error == nil {
                    self.placeholderImage.isHidden = true
                }
            }
        }
        
    }
}
