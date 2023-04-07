//
//  YWTimer.swift
//  YWTigerkin
//
//  Created by odd on 4/7/23.
//

import Foundation

typealias YWTask = (_ cancel: Bool) -> Void
/// 代码延迟运行
///
/// - Parameters:
///   - delayTime: 延时时间。比如：.seconds(5)、.milliseconds(500)
///   - qosClass: 要使用的全局QOS类（默认为 nil，表示主线程）
///   - task: 延迟运行的代码
/// - Returns: Task?
@discardableResult
func bk_delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil, _ task: @escaping () -> Void) -> YWTask? {
    
    func dispatch_later(block: @escaping () -> Void) {
        let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
        dispatchQueue.asyncAfter(deadline: .now() + delayTime, execute: block)
    }
    
    var closure: (() -> Void)? = task
    var result: YWTask?
    
    let delayedClosure: YWTask = { cancel in
        if let internalClosure = closure {
            if !cancel {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result
    
}

/// 取消代码延时运行
func delayCancel(_ task: YWTask?) {
    task?(true)
}


/// GCD定时器倒计时
///
/// - Parameters:
///   - timeInterval: 间隔时间
///   - repeatCount: 重复次数
///   - handler: 循环事件,闭包参数: 1.timer 2.剩余执行次数
func dispatchTimer(timeInterval: Double, repeatCount: Int, handler: @escaping (DispatchSourceTimer?, Int) -> Void) {
    
    if repeatCount <= 0 {
        return
    }
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    var count = repeatCount
    timer.schedule(deadline: .now(), repeating: timeInterval)
    timer.setEventHandler {
        count -= 1
        DispatchQueue.main.async {
            handler(timer, count)
        }
        if count == 0 {
            timer.cancel()
        }
    }
    timer.resume()
    
}

/// GCD实现定时器
///
/// - Parameters:
///   - timeInterval: 间隔时间
///   - handler: 事件
///   - needRepeat: 是否重复
func dispatchTimer(timeInterval: Double, handler: @escaping (DispatchSourceTimer?) -> Void, needRepeat: Bool) {
    
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    timer.schedule(deadline: .now(), repeating: timeInterval)
    timer.setEventHandler {
        DispatchQueue.main.async {
            if needRepeat {
                handler(timer)
            } else {
                timer.cancel()
                handler(nil)
            }
        }
    }
    timer.resume()
    
}
