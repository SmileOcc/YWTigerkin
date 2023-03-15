//
//  YWDate.swift
//  YWTigerkin
//
//  Created by odd on 3/15/23.
//

import Foundation

public enum LDateFormat: Int {
    // 始终显示精确日期和时间
    case precise
    // specific 始终显示具体分钟
    case specific
    // short突出处理短时间
    case short
}

private extension DateFormatter {
    static func cached(withFormat format: String) -> DateFormatter {
        var cachedFormatters = YWDate.shared.cachedFormatters
        if let cachedFormatter = cachedFormatters[format] {
            return cachedFormatter
        }
        let formatter = DateFormatter()
        formatter.locale = NSLocale.system // fix:iOS15.4~15.6 12小时制日期格式显示问题
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        cachedFormatters[format] = formatter
        return formatter
    }
}

class YWDate: NSObject {
    /// 单例
    fileprivate static let shared = YWDate.init()
    ///  缓存DateFormatter对象池
    fileprivate var cachedFormatters = [String: DateFormatter]()
    /// LDateFormat为specific生效
    fileprivate let defaultFormat = "yyyy-MM-dd HH:mm:ss"
    /// 内部处理时间格式
    fileprivate lazy var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = YWDate.shared.defaultFormat
        format.locale = NSLocale.system // fix:iOS15.4~15.6 12小时制日期格式显示问题
        format.calendar = Calendar(identifier: .gregorian)
        return format
    }()
    
    /**
     String转Date
     @param from String
     @param format 例如：yyyy-MM-dd
     */
    public class func date(from: String, format: String) -> Date? {
        let dateFormatter = DateFormatter.cached(withFormat: format)
        return dateFormatter.date(from: from)
    }
    
    /**
     Date转String
     @param from Date
     @param format 例如：yyyy-MM-dd
     */
    public class func string(from: Date, format: String) -> String {
        let dateFormatter = DateFormatter.cached(withFormat: format)
        return dateFormatter.string(from: from)
    }
    
    /**
         时间戳转String
         @param timeStamp Int 时间戳
         @param format 例如：yyyy-MM-dd
         */
        public class func string(_ timeStamp: Int, format: String) -> String {
            let dateFormatter = DateFormatter.cached(withFormat: format)
            let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp)) as Date
            return dateFormatter.string(from: date)
        }
    
    /**
     时间转换方法
     @param timeStamp 时间戳
     @param format 时间处理类型  precise // 始终显示精确日期和时间 specific // 始终显示具体分钟 short // 突出处理短时间
     */
    public class func timeToString(_ timeStamp: Int, _ format: LDateFormat) -> String {
        let timeStr = NSNumber(value: timeStamp).stringValue
        // 时间戳位数大于10视为毫秒级，转秒级除以1000
        var timeInterval = timeStamp
        if timeStr.count > 10 {
            timeInterval /= 1000
        }
        switch format {
        case .precise:
            return preciseTimeStamp(timeInterval)
        case .specific:
            return specificTimeStamp(timeInterval)
        case .short:
            return shortTimeStamp(timeInterval)
        }
    }
    
    private class func preciseTimeStamp(_ timeStamp: Int) -> String {
        // 所有时间 默认 yyyy-MM-DD xx：xx：xx
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp)) as Date
        return YWDate.shared.dateFormatter.string(from: date)
    }
    
    private class func specificTimeStamp(_ timeStamp: Int) -> String {
        let timeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval) as Date
        // 当天0:00-24:00 xx:xx
        if date.isToday() {
            return timeToString(timeInterval, "HH:mm")
        }
        // 昨天0:00-24:00 昨天xx:xx
        if date.isYesterday() {
            let timeStr = timeToString(timeInterval, "HH:mm")
            return String(format: "昨天 %@", timeStr)
        }
        // 超过昨天且当年 MM-DD xx：xx
        if date.isThisYear() {
            return timeToString(timeInterval, "MM-dd HH:mm")
        }
        // 超过昨天且跨年 yyyy-MM-DD xx：xx
        return timeToString(timeInterval, "yyyy-MM-dd HH:mm")
    }
    
    private class func shortTimeStamp(_ timeStamp: Int) -> String {
        var timeInterval: Int = 0, temp: Int = 0
        // 从传入时间到当前时间的差值 秒级
        timeInterval =  Int(Date().timeIntervalSince1970) - timeStamp
        // 获取有多少分钟
        temp = timeInterval / 60
        if temp < 1 { // 1分钟内 刚刚
            return "刚刚"
        }
        if temp < 60 { // 1小时内 xx分钟前
            return String(format: "%ld分钟前", temp)
        }
        // 获取有多少小时
        temp /= 60
        if temp < 24 { // 24小时内 xx小时前 （不考虑00:00前后，只要在24小时内）
            return String(format: "%ld小时前", temp)
        }
        let timeStampInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeStampInterval) as Date
        if date.isYesterday() { // 超过24小时且在昨天 昨天
            return "昨天"
        }
        if date.isThisYear() { // 超过昨天且当年 MM-DD
            return timeToString(timeStampInterval, "MM-dd")
        }
        // 超过昨天且跨年 yyyy-MM-DD
        return timeToString(timeStampInterval, "yyyy-MM-dd")
    }
    
    private class func timeToString(_ timeStamp: TimeInterval, _ format: String?) -> String {
        let date = NSDate(timeIntervalSince1970: timeStamp) as Date
        let time = YWDate.string(from: date, format: format ?? YWDate.shared.defaultFormat)
        return time
    }
    
    
    
    
    
}

extension Date {
    
    ////
    ///
    func isToday() -> Bool {
        let calendar = Calendar.current
        //当前时间
        let nowComponents = calendar.dateComponents([.day,.month,.year], from: Date() )
        //self
        let selfComponents = calendar.dateComponents([.day,.month,.year], from: self as Date)
        
        return (selfComponents.year == nowComponents.year) && (selfComponents.month == nowComponents.month) && (selfComponents.day == nowComponents.day)
    }
    
    func isYesterday() -> Bool {
        let calendar = Calendar.current
        //当前时间
        let nowComponents = calendar.dateComponents([.day], from: Date() )
        //self
        let selfComponents = calendar.dateComponents([.day], from: self as Date)
        let cmps = calendar.dateComponents([.day], from: selfComponents, to: nowComponents)
        return cmps.day == 1
        
    }
    
    func isSameWeek() -> Bool {
        let calendar = Calendar.current
        //当前时间
        let nowComponents = calendar.dateComponents([.day,.month,.year], from: Date() )
        //self
        let selfComponents = calendar.dateComponents([.weekday,.month,.year], from: self as Date)
        
        return (selfComponents.year == nowComponents.year) && (selfComponents.month == nowComponents.month) && (selfComponents.weekday == nowComponents.weekday)
    }
    
    func weekdayStringFromDate() -> String {
        let weekdays:NSArray = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar.init(identifier: .gregorian)
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: self as Date)
        return weekdays.object(at: theComponents.weekday!) as! String
    }
    
    /**
     *  是否为今年
     */
    func isThisYear() -> Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: self)
        let result = nowCmps.year == selfCmps.year
        return result
    }
    
    /**
     *  获得与当前时间的差距
     */
    func deltaWithNow() -> DateComponents{
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.hour,.minute,.second], from: self, to: Date())
        return cmps

    }
    /// 根据本地时区转换
    static func getNowDateFromatAnDate(_ anyDate: Date?) -> Date {
        //设置源日期时区
        let sourceTimeZone = NSTimeZone(abbreviation: "UTC")
        //或GMT
        //设置转换后的目标日期时区
        let destinationTimeZone = NSTimeZone.local as NSTimeZone
        //得到源日期与世界标准时间的偏移量
        var sourceGMTOffset: Int? = nil
        if let aDate = anyDate {
            sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: aDate)
        }
        //目标日期与本地时区的偏移量
        var destinationGMTOffset: Int? = nil
        if let aDate = anyDate {
            destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: aDate)
        }
        //得到时间偏移量的差值
        let interval = TimeInterval((destinationGMTOffset ?? 0) - (sourceGMTOffset ?? 0))
        //转为现在时间
        var destinationDateNow: Date? = nil
        if let aDate = anyDate {
            destinationDateNow = Date(timeInterval: interval, since: aDate)
        }
        return destinationDateNow!
    }
}
