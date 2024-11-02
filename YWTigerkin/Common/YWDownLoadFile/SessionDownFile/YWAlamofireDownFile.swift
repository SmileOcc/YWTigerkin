//
//  YWAlamofireDownFile.swift
//  YWTigerkin
//
//  Created by odd on 11/2/24.
//

import UIKit
import Alamofire

class YWAlamofireDownFile: NSObject {
    
    static func download() {
        let fileURL = URL(string: "https://headcollect.oss-cn-beijing.aliyuncs.com/train_model/101/ios/best.mlmodel")!
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        AF.download(fileURL, to: destination)
            .downloadProgress { progress in
                print("下载进度: \(progress.fractionCompleted)")
            }
            .response { response in
                if let error = response.error {
                    print("下载失败: \(error)")
                } else {
                    print("下载成功! " + (response.fileURL?.absoluteString ?? ""))
                }
            }
    }
}
