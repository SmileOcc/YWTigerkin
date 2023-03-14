//
//  YWOrigRequest.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import Foundation

typealias RequestCompletionBlock = (_ response:URLResponse?,_ responseObject:Dictionary<String, Any>?,_ error:Error?) -> Void

class OrigRequest: NSObject {
       //声明单例
       static let standard = OrigRequest()

       func enqueueGETRequest(urlStr:String, completionHandler:RequestCompletionBlock? = nil){
        
        let destUrl:URL = URL(string: urlStr)!
        ///发送请求的 session 对象
        let session = URLSession.shared
        ///请求的 request
        var request = URLRequest(url: destUrl)
        request.httpMethod = "GET"
        //设置请求头参数
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        request.timeoutInterval = 60.0;

        session.configuration.timeoutIntervalForRequest = 30.0
        
        let task:URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            
            guard error == nil, let data:Data = data, let _:URLResponse = response else {
                print("请求出错：\(error!.localizedDescription)")
                return
            }
            
            let dataStr = String(data: data, encoding: String.Encoding.utf8)!
            let responseObject = self.responseObjectFromJSONString(jsonString: dataStr)
            print("POST请求 URL=\(destUrl)")
            print("GET请求结果：\(responseObject)")
        }
        //开始请求
        task.resume()
     }

    func enqueuePOSTRequest(urlStr:String,params:Dictionary<String,Any>? = nil,completionHandler:RequestCompletionBlock? = nil){
            
            let destUrl:URL = URL(string: urlStr)!
            ///post请求参数
            let paramsData = try? JSONSerialization.data(withJSONObject: params ?? Dictionary() , options: [])
            
            ///发送请求的 session 对象
            let session = URLSession.shared
            ///请求的 request
            var request = URLRequest(url: destUrl)
            
            request.httpMethod = "POST"
            ///post请求参数
            request.httpBody = paramsData
            
            //根据API的要求，设置请求头参数
            request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
            
            ///发送 POST请求
            let task:URLSessionDataTask = session.dataTask(with: request) { data, response, error in
                
                guard error == nil, let data:Data = data, let _:URLResponse = response else {
                    print("请求出错：\(error!.localizedDescription)")
                    return
                }
                
                //data 转json字符串
                let dataStr = String(data: data, encoding: String.Encoding.utf8)!
                print("dataStr = \(dataStr)")
                /*
                //data 转 json
                if let any = try?JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    let dic :Dictionary = any as! Dictionary<String,Any>
                    print("dic=：\(dic)")
                }
                */
        
                let responseObject = self.responseObjectFromData(data: data)
                
                print("POST请求 URL=\(destUrl) 参数：\(params ?? Dictionary())")
                print("POST请求结果：\(responseObject)")
            }
            //开始请求
            task.resume()
        }
      ///jsonString 转 json
     func responseObjectFromJSONString(jsonString:String) -> Dictionary<String, Any> {
        let jsonData:Data = jsonString.data(using: String.Encoding.utf8)!
        let resultDic = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
        if resultDic != nil {
            return resultDic  as! Dictionary<String, Any>
        }
        return Dictionary()
    }
    
    ///data 转 JSON
        func responseObjectFromData(data:Data) -> Dictionary<String, Any> {
            let resultDic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if resultDic != nil {
                return resultDic  as! Dictionary<String, Any>
            }
            return Dictionary()
        }
}
