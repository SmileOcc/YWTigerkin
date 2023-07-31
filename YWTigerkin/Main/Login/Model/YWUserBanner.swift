//
//  YWUserBanner.swift
//  YWTigerkin
//
//  Created by odd on 7/28/23.
//

import Foundation

struct YWUserBanner: Codable {
    let dataList: [BannerList]?
    
    enum CodingKeys: String, CodingKey {
        case dataList = "dataList"
    }
}

struct BannerList: Decodable,Encodable {
    

        let bannerID: Int?
        let adType: Int?
        let adPos: Int?
        let pictureURL: String?
      //  var invalidTime: String?
       let originJumpURL, newsID, bannerTitle, tag: String?
       var jumpType: String? 
        var jumpURL: String? {
            get {
                return self.originJumpURL
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case bannerID = "id"
            case adType = "type"
            case bannerTitle = "bannerName"
            case adPos = "priority"
            case pictureURL = "img"
            case originJumpURL = "redirectPosition"
            case jumpType = "redirectMethod"
         //   case invalidTime = "endDate"
            case newsID,tag
        }
    
}
