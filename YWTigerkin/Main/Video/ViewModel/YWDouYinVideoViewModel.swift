//
//  YWDouYinVideoViewModel.swift
//  YWTigerkin
//
//  Created by odd on 7/1/23.
//

import UIKit
import URLNavigator
import RxSwift
import RxCocoa
import NSObject_Rx

class YWDouYinVideoViewModel: HUDServicesViewModel , HasDisposeBag {
    
    typealias Services = HasYWCommonService
    
    var navigator: YWNavigatorServicesType!

    var hudSubject: PublishSubject<HUDType>! = PublishSubject<HUDType>()

    var datas:[YWDouYinVideoModel] = []
    
    var isRefresh: Bool = true
    var hasMore: Bool = false
    var currentPage: Int = 0
    
    var dataResponse: YWResultResponse<YWHomeModel>?
    let resultSubject = PublishSubject<(Bool, String)>()

    var services: Services! {
        didSet {
            
            dataResponse = {[weak self] (response) in
                guard let `self` = self else {return}
                self.hudSubject.onNext(.hide)
                switch response {
                    case .success(let result, let code):
                    switch code {
                    case .success?:
                        
                        let userInfo = result.result

                        func setUserInfo(){
                            if let ccc = userInfo {
                                print("name: \(ccc.banner)")
                            }
                            print("=================")

                            print("=================")
                        }
                        
                        setUserInfo()
                        self.resultSubject.onNext((true,""))
                    default:
                        if let msg = result.message {
                            self.hudSubject.onNext(.error(msg, false))
                            
                        }
                    }
                case .failed(_):
                    print("error")
                    self.hudSubject.onNext(.error(YWConstant.requestNetError, false))
                }
            
                
            }
        }
    }
    
    func loadData(isMore:Bool) {
        
        self.isRefresh = !isMore
        var page = currentPage + 1
        if !isMore {
            page = 0
        }
        
        //self.services.commonService.request(.videoList("", page: "0", pageSize: "20"), response: dataResponse).disposed(by: self.disposeBag)
        
        self.handResult(result: [:])
        
    }
    
    func handResult(result:[String:Any]?) {
        
        if self.isRefresh {
            currentPage = 0
            self.datas.removeAll()
        } else {
            currentPage += 1
        }
        
        var list:[YWDouYinVideoModel] = []

    

    

    

    

    

        let mp4s:[String] = ["https://v-cdn.zjol.com.cn/280443.mp4",
                             "https://v-cdn.zjol.com.cn/276982.mp4",
                             "https://v-cdn.zjol.com.cn/276984.mp4",
                             "https://media.w3.org/2010/05/sintel/trailer.mp4",
                             "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8",
                             "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
                             "https://www.cambridgeenglish.org/images/153149-movers-sample-listening-test-vol2.mp3",
                             "https://www.cambridgeenglish.org/images/506891-a2-key-for-schools-listening-sample-test.mp3",                             
                             "http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4",
                             "http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg",
                             "https://sample-videos.com/video123/mkv/720/big_buck_bunny_720p_5mb.mkv",
                             "https://sample-videos.com/video123/mkv/720/big_buck_bunny_720p_10mb.mkv",
                             
                             "https://sample-videos.com/video123/3gp/144/big_buck_bunny_144p_1mb.3gp",
                             "https://sample-videos.com/video123/3gp/144/big_buck_bunny_144p_2mb.3gp",
                             "https://sample-videos.com/video123/3gp/144/big_buck_bunny_144p_5mb.3gp",
                             "https://sample-videos.com/video123/3gp/144/big_buck_bunny_144p_10mb.3gp"]
        for i in 0..<mp4s.count {
            let model = YWDouYinVideoModel()
            model.cid = "id_\(i)"
            model.url = mp4s[i]
            model.name = "视频名称——\(i)"
            list.append(model)
        }
        
        
        hasMore = list.count > 20 ? true : false
        
        self.datas.append(contentsOf: list)
    }
}

