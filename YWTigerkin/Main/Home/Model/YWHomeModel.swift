//
//  YWHomeModel.swift
//  YWTigerkin
//
//  Created by odd on 3/6/23.
//

import Foundation

struct YWHomeModel: Codable {
    let banner:[YWHomeBanner]?
    let slideImgArray:[YWHomeImgModel]?
    let marquee: [YWMarquee]?
    let noConentKey: String?
    let blocklist: [YWBlocklist]?
    
    enum CodingKeys: String, CodingKey {
        case banner,marquee,noConentKey,blocklist
        case slideImgArray = "slide_img"
    }
}


struct YWHomeBanner: Codable {
    let heigth: String?
    let actionType: String?
    let id: String?
    let image_url: String?
    let width: String?
    let name: String?
    let url: String


}

struct YWHomeImgModel: Codable {
    let heigth: String?
    let actionType: String?
    let id: String?
    let image_url: String?
    let width: String?
    let name: String?
    let url: String?

}

struct YWMarquee: Codable {
    let heigth: String?
    let image_url: String?
    let width: String?
    let name: String?
    let url: String?

}



class YWBlocklist: NSObject, Codable {
    let type: String?
    let images: [YWSlideImages]?
}

class YWSlideImages: NSObject, Codable {
    var type: String?
    let heigth: CGFloat?
    let imageUrl: String?
    let width: CGFloat?
    let name: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case type,heigth,width,name
        case url
        case imageUrl = "image_url"
    }
}


class YWTestModel: Codable {
    var id: String?
    var name: String?
    var isSelect: Bool = false
}

class YWTestNobject: NSObject {
    var name: String?
    var code: Int = 0
    var isSelect: Bool = false
    
    func dataFormDic(dic:[String:Any]) {
        self.name = dic["name"] as? String ?? ""
        self.code = dic["code"] as? Int ?? 0
        self.isSelect = dic["select"] as? Bool ?? false
    }
}
