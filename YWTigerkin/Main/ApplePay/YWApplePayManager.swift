//
//  YWApplePayManager.swift
//  YWTigerkin
//
//  Created by odd on 6/18/23.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class YWApplePayManager: NSObject {

    static let shareInstance = YWApplePayManager()
    
    static let sharedSecret = "appstore safe secret"
    static func setUpApple() {
        //AppDelegate添加以下代码，在启动时添加应用程序的观察者可确保在应用程序的所有启动过程中都会持续，从而允许应用程序接收所有支付队列通知，如果有任何未完成的处理，将会触发block,以便我们更新UI
        // 上次支付没有调用finishTransaction，下次重新启动会触发一次，后面再重新启动不会触发
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            //是否登录
            let isLogin = true
            if !isLogin {
                return
            }
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
    }
    
    //1.购买 产品id
    static func pay(product:YWApplePayProduct,completeHandle:@escaping (YWApplePayResult) -> Void) {
        
        if !SwiftyStoreKit.canMakePayments {
            print("您的手机没有打开程序内付费购买")
            
            let resultInfo = YWApplePayResult.defaultModel()
            resultInfo.msg = "您的手机没有打开程序内付费购买"
            resultInfo.logMsg = "您的手机没有打开程序内付费购买"
            resultInfo.product = product
            resultInfo.isSuccess = false
            
            completeHandle(resultInfo)
            return
        }
        
        SwiftyStoreKit.purchaseProduct(product.productId, quantity: product.count, atomically: false) { purchaseResult in
            switch purchaseResult {
            case .success(let purchase):
                //处理交易
                YWApplePayManager.handleTransaction(product:product, transaction: purchase.transaction) { result in
                    completeHandle(result)
                }
                
            case .error(let error):
                switch error.code {
                case .unknown:
                    print("Unknown error. Please contact support")
                    
                case .clientInvalid:
                    print("Not allowed to make the payment")
                    
                case .paymentCancelled:
                    
                    break
                case .paymentInvalid:
                    
                    print("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    print("The device is not allowed to make the payment")
                    
                case .storeProductNotAvailable:
                    print("The product is not available in the current storefront")
                    
                case .cloudServicePermissionDenied:
                    print("Access to cloud service information is not allowed")
                    
                case .cloudServiceNetworkConnectionFailed:
                    print("Could not connect to the network")
                    
                case .cloudServiceRevoked:
                    print("User has revoked permission to use this cloud service")
                    
                default :
                    print("其他错误")
                }
                
                let resultInfo = YWApplePayResult.defaultModel()
                resultInfo.msg = "支付失败"
                resultInfo.logMsg = "\(error)"
                resultInfo.product = product
                resultInfo.isSuccess = false
                completeHandle(resultInfo)
            }
        }
    }
      
    //2.处理交易
    static func handleTransaction(product:YWApplePayProduct?, transaction:PaymentTransaction,completeHandle:@escaping ((YWApplePayResult) -> Void)) {
        
        //获取receipt
        SwiftyStoreKit.fetchReceipt(forceRefresh:false) { result in
            
            switch result {
                
            case .success(let receiptData):
                
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                
                print("获取校验字符串Fetch receipt success:\n\(encryptedReceipt)")
                
                //3.服务端票据校验
                //3.1存储票据
                YWApplePayManager.saveRecipt(encryptedReceipt)
                YWApplePayManager.verifyReceipt(product: product, receipt: encryptedReceipt, isService: false) { resultInfo in
                    
                    if resultInfo.isSuccess {
                        YWApplePayManager.deleteReceipt(encryptedReceipt)
                        SwiftyStoreKit.finishTransaction(transaction)
                        //3.2删除票据
                        

                    }
                    completeHandle(resultInfo)
                }
                
                
                
            case .error(let error):
                print(" --- Fetch receipt failed: \(error)")
                
                let resultInfo = YWApplePayResult.defaultModel()
                resultInfo.msg = "支付失败"
                resultInfo.logMsg = "支付票据获取失败"
                resultInfo.product = product
                resultInfo.isSuccess = false
                completeHandle(resultInfo)
            }
            
        }
        
    }
    
    static func verifyReceipt(product:YWApplePayProduct?, receipt:String, isService: Bool ,completeHandle:@escaping ((YWApplePayResult) -> Void)) {
        
        //后台服务
        if isService {
            
        } else {
            // 本地验证（沙盒、线上）
            YWApplePayManager.verifyReceiptLoacl(product:product, service: .sandbox, completeHandle: completeHandle)
        }
    }
    
    //本地校验苹果数据
    static func verifyReceiptLoacl(product:YWApplePayProduct?, service: AppleReceiptValidator.VerifyReceiptURLType ,completeHandle:@escaping ((YWApplePayResult) -> Void)) {
        
        let receiptValidator = AppleReceiptValidator(service: service, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: receiptValidator) { (result) in
            switch result {
            case .success (let receipt):
                let status: Int = receipt["status"] as! Int
                //沙盒测试
                if status == 21007 {
                }
                print("receipt：\(receipt)")
                
                let resultInfo = YWApplePayResult.defaultModel()
                resultInfo.msg = "支付成功"
                resultInfo.logMsg = "支付票据本地校验成功"
                resultInfo.product = product
                resultInfo.isSuccess = true
                completeHandle(resultInfo)
            case .error(let error):
                print("error：\(error)")
                
                let resultInfo = YWApplePayResult.defaultModel()
                resultInfo.msg = "支付校验失败"
                resultInfo.logMsg = "支付票据本地校验失败\(error)"
                resultInfo.product = product
                resultInfo.isSuccess = false
                completeHandle(resultInfo)
                
            }
        }
    }
    
    func restorePurchases(_ completeHolder: ((Bool)->Void)? = nil) {
        
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    
                    //处理交易
                    //YWApplePayManager.handleTransaction(product:nil, transaction: purchase as! PaymentTransaction) { dialog, code in }
                }
                
                print("Restore Success: \(results.restoredPurchases)")
            }
            else {
                print("Nothing to Restore")
            }
            if completeHolder != nil {
                completeHolder!(true)
            }
        }
        
    }
    
    
    //MARK: -票据处理 存储钥匙串里 SAMKeychain 根据【用户ID区】分开
    // 先存储票据，校验成功在删除，如果每次启动本地有票据，都发个后台校验一下，校验成功在移除

    static func userId() -> String {
        
        return "user_id"
    }
    static func saveRecipt(_ recipt: String) {
        
        var currentArray:[String] = []
        //先读取钥匙串中的
        if let localArray = YWApplePayManager.localRecipt() {
           if false == (localArray.contains { oldRecipt in
                if oldRecipt == recipt {
                    return true
                } else {
                    return false
                }
           }) {
               currentArray.append(contentsOf: localArray)
               currentArray.append(recipt)
               
               //存 数组转json字符串
           }
        }
    }
    
    static func deleteReceipt(_ receipt: String) {
        if var localArray = YWApplePayManager.localRecipt() {
            localArray.removeAll { oldReceipt in
                if oldReceipt == receipt {
                    return true
                }
                return false
            }
            //在重新存储
        }
    }

    static func localRecipt() -> [String]? {
        //读取json数组字符串，转数组
        return []
    }
}
