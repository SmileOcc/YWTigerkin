//
//  YWTestOCSwiftCatchCtrl.swift
//  YWTigerkin
//
//  Created by odd on 11/2/24.
//

import UIKit
import WebKit

enum YWCommonError: Error {
    case businessError(code: Int, msg: String)
    case systemError(msg: String)
}


class YWTestOCSwiftCatchCtrl: YWBaseViewController {

    var ttstring = ""
    var dict: [String: Double] = [:]

    let task: WKURLSchemeTask! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        self.testMessageLab.isHidden = false
        self.testBtn.isHidden = false
        
        self.testMessageLab.text = "\n处理catch，同时捕获oc、swift的catch \nWKURLSchemeTask 要在oc下才能捕获，所以要特殊处理\n"
        
    }
    
    override func testAction() {
        super.testAction()
        
        self.testCatch()
        
//        self.crashOfRaceConditionInString()
//        self.crashOfRaceConditionInDictionary()
    }
    
    func testCatch() {
        do {
//            let _ = try YWExceptionCatch.catch{
//                //task如执行完didfinish后，还继续触发其他方法会崩溃
//                return self.task.didFinish()
//            }
            
//            try self.task.didFinish()// 这个swift下捕获不到，要在OC下
            
            try self.testThrow(false)
            
            let _ = try YWExceptionCatch.catch{
                return try self.testBThrow(false)
            }
            try YWExceptionCatch.commonCatch {
                try self.testBThrow(false)
            }
            
            
            try YWExceptionCatch.commonCatch {
                try self.testBThrow(false)
                try self.testBThrow(false)
                try self.testBThrow(true)//异常
            }

        } catch {
            print("有异常信息：" + "\(error.localizedDescription)")
            
            self.testMessageLab.text = (self.testMessageLab.text ?? "") + "\n" + "\(error.localizedDescription)"
        }
    }
    
    func testThrow(_ isError: Bool) throws  {
        if (isError) {
            throw YWCommonError.systemError(msg: "通用系统错误")
        }
    }
    
    func testBThrow(_ isError: Bool) throws {
        
        try self.testThrow(isError)

    }
    
    //当内容超长时 崩溃：malloc: double free for ptr 0x7fd149a55a00
    func crashOfRaceConditionInString() {

        for _ in 0..<1150 {
            DispatchQueue.concurrentPerform(iterations: 4) { index in
                if index % 2 == 0 {
                    ttstring += "ABC"
                } else {
                    ttstring += "DEF"
                }
            }
        }
    }
    
    //这个会崩溃
//    会报Dictionary.subscript.getter
    func crashOfRaceConditionInDictionary() {
        let key = "ABCD"
        
        for _ in 0..<1150 {
            DispatchQueue.concurrentPerform(iterations: 2) { index in
                if index % 2 == 0 {
                   print(dict[key] as Any)
                } else {
                   dict[key] = Double(index)
                }
            }
        }
        
    }

}
