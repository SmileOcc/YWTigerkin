//
//  YWTestDicWriteReadCtrl.swift
//  YWTigerkin
//
//  Created by odd on 11/2/24.
//

import UIKit

class YWTestDicWriteReadCtrl: YWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testBtn.isHidden = false
        self.testMessageLab.isHidden = false
        self.testMessageLab.text = "\n[:]在多线程下读取会报Dictionary.subscript.getter，\n可以添加NSLock 或添加到队列里，异步写，同步读，\n或使用NSMutableDictionary\n"
         
    }
    
    override func testAction() {
        super.testAction()
        
        for i in 0...100 {
            writeT(i: i)
        }
        abctt()
        print("========== " + "eeeee  " + Thread.current.description)
    }
    

    let kkkQueue = DispatchQueue(label: "createActivityThreads")
    let lock = NSLock()
    
    //这个多线程中读写有问题，会报Dictionary.subscript.getter
    //可以读写添加锁，或添加到队列里，异步写，同步读
    //参考解释
    //https://zeroonet.com/2024/05/05/race-condition-in-swift-data-structure/
    //https://github.com/swiftlang/swift/blob/main/stdlib/public/core/DictionaryVariant.swift

    var list:[Int:Bool] = [:]
    
    //这个字典不会
    var listDic:NSMutableDictionary = NSMutableDictionary()

    func abctt() {
        for i in 0...100 {
//            self.kkkQueue.sync {
            print("========== aaaa" + "\(i)  "  + Thread.current.description)
            //通过添加锁，或队列同步读取
            self.readLock(i: i)
//            }
        }
        print("========== " + "bbbb  " + Thread.current.description)
    }
    
    func readLock(i:Int) {
        //需要打开锁
//        defer {
//            self.lock.unlock()
//        }
//        self.lock.lock()
        
        let value = self.list[i]

    }
    
    
    func writeT(i:Int) {
        self.kkkQueue.async {
            print("========== " + "cccc  " + "\(i) " + Thread.current.description)
            self.writeLock(i: i)
        }
    }
    
    func writeLock(i: Int) {
        defer {
            self.lock.unlock()
        }
        self.lock.lock()
        
        self.list[i] = true
        print("========== " + "eeee  " + "\(i) " + Thread.current.description)

    }

}
