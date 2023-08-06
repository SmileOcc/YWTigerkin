//
//  YWDateHelper.swift
//  YWTigerkin
//
//  Created by odd on 8/5/23.
//

import UIKit

enum YWDateFomatterStyle: String {
    case `default` = "yyyy-MM-dd HH:mm:ss"
    case midLong = "yyyy-MM-dd HH:mm"
    case mid = "MM-dd HH:mm"
    case short = "HH:mm"
    case scale = "HH:mm:ss"
    case scaleDay = "yyyy-MM-dd"
    case yyyyMMdd = "yyyyMMdd"
    case yyyyMM = "yyyy-MM"
}


@objc enum YWCommonDateFormat: Int {
    case DF_MD          // 英文：MM dd                  中文：MM-dd
    case DF_MDY         // 英文：MM dd yyyy             中文：yyyy-MM-dd
    case DF_MDYHM       // 英文：MM dd yyyy HH:mm       中文：yyyy-MM-dd HH:mm
    case DF_MDYHMS      // 英文：MM dd yyyy HH:mm:ss    中文：yyyy-MM-dd HH:mm:ss
    case DF_MDHM        // 英文：MM dd HH:mm            中文：MM-dd HH:mm
    case DF_MDHMS       // 英文：MM dd HH:mm:ss         中文：MM-dd HH:mm:ss
    case DF_MY          // 英文：MM yyyy                中文：yyyy-MM

    func formatString(_ scaleType: YWCommonDateScaleType = .scale) -> String {
        
        let scaleString = scaleType.scaleString
        switch self {
        case .DF_MD:
            if YWUserManager.isENMode() {
                return "dd MM"
            } else {
                return "MM\(scaleString)dd"
            }
            
        case .DF_MDY:
            if YWUserManager.isENMode() {
                return "dd MM, yyyy"
            } else {
                return "yyyy\(scaleString)MM\(scaleString)dd"
            }
            
        case .DF_MDYHM:
            if YWUserManager.isENMode() {
                return "dd MM, yyyy HH:mm"
            } else {
                return "yyyy\(scaleString)MM\(scaleString)dd HH:mm"
            }
            
        case .DF_MDYHMS:
            if YWUserManager.isENMode() {
                return "dd MM, yyyy HH:mm:ss"
            } else {
                return "yyyy\(scaleString)MM\(scaleString)dd HH:mm:ss"
            }
            
        case .DF_MDHM:
            if YWUserManager.isENMode() {
                return "dd MM, HH:mm"
            } else {
                return "MM\(scaleString)dd HH:mm"
            }

        case .DF_MDHMS:
            if YWUserManager.isENMode() {
                return "dd MM, HH:mm:ss"
            } else {
                return "MM\(scaleString)dd HH:mm:ss"
            }
        case .DF_MY:
            if YWUserManager.isENMode() {
                return "MM, yyyy"
            } else {
                return "yyyy\(scaleString)MM"
            }
        }
    }
}

@objc enum YWCommonDateScaleType: Int {
    case scale = 0      //"-"
    case slash          //"/"
    case space          //" "
    
    var scaleString: String {
        switch self {
        case .scale:
            return "-"
        case .slash:
            return "/"
        case .space:
            return " "
        }
    }
}

extension DateFormatter {
    class func en_US_POSIX() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        return dateFormatter
    }
    
    class func zh_Hans_CN() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")

        return dateFormatter
    }
}

class YWDateHelper: NSObject {
    
    static let dateFormatter = DateFormatter.zh_Hans_CN()
    static let calendar = Calendar.init(identifier: .gregorian)
    
    
    class func shortMonthName(_ month: Int) -> String {
        let months = ["", "Jan.", "Feb.", "Mar.", "Apr.", "May.", "Jun.", "Jul.", "Aug.", "Sept.", "Oct.", "Nov.", "Dec."]
        if month >= months.count || month == 0 {
            return months.first ?? ""
        }
        return months[month]
    }
    class func enMonthName(_ month: Int) -> String {
        let months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
        if month >= months.count || month == 0 {
            return months.first ?? ""
        }
        return months[month]
    }
    
    class func dateSting(from timeInterval: TimeInterval, formatter: String) -> String {
        
        var interval = timeInterval
        if String(timeInterval).count >= 13 {
            interval = timeInterval / 1000.0
        }
        let date = Date(timeIntervalSince1970: interval)
        dateFormatter.dateFormat = formatter
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func dateSting(from timeInterval: TimeInterval, formatterStyle: YWDateFomatterStyle = .default) -> String {
        
        var interval = timeInterval
        if String(timeInterval).count >= 13 {
            interval = timeInterval / 1000.0
        }
        let date = Date(timeIntervalSince1970: interval)
        dateFormatter.dateFormat = formatterStyle.rawValue
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func unixTime(from dateString: String, formatter: String) -> TimeInterval {
        
        dateFormatter.dateFormat = formatter
        if let date = dateFormatter.date(from: dateString) {
            return date.timeIntervalSince1970
        }
        return 0
    }
    
    class func weekDay(from timeInterval: TimeInterval) -> String {
        
        var interval = timeInterval
        if String(timeInterval).count >= 13 {
            interval = timeInterval / 1000.0
        }
        let weekDay = [YWLanguageUtility.kLang(key: "common_Sunday"),
                       YWLanguageUtility.kLang(key: "common_Monday"),
                       YWLanguageUtility.kLang(key: "common_Tuesday"),
                       YWLanguageUtility.kLang(key: "common_Wednesday"),
                       YWLanguageUtility.kLang(key: "common_Thursday"),
                       YWLanguageUtility.kLang(key: "common_Friday"),
                       YWLanguageUtility.kLang(key: "common_Saturday")]
        
        let date = Date(timeIntervalSince1970: interval)
        let weekDayIndex = calendar.component(.weekday, from: date)
        //let components = calendar.dateComponents([.weekday], from: date)
        if weekDayIndex >= 1, weekDayIndex < weekDay.count {
            return weekDay[weekDayIndex - 1]
        }
        return ""
    }
    
    class func sameDay(_ fromTime: TimeInterval,_ toTime: TimeInterval) -> Bool {
        let fromDate = Date(timeIntervalSince1970: fromTime)
        let toDate = Date(timeIntervalSince1970: toTime)
        if calendar.compare(fromDate, to: toDate, toGranularity: .weekday) == .orderedSame {
            return true
        }
        return false
    }
    
    class func dateSting(from date: Date, formatterStyle: YWDateFomatterStyle = .yyyyMMdd) -> String {
        dateFormatter.dateFormat = formatterStyle.rawValue
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    
    /// 将Unix时间戳转化为时间通用样式
    /// - Parameters:
    ///   - unixTime: unix时间戳
    ///   - format: 日期格式   参考YWCommonDateFormat
    /// - Returns: 通用日期字符串
    @objc class func commonUnixDateString(_ unixTime: TimeInterval, format: YWCommonDateFormat = .DF_MDY, scaleType: YWCommonDateScaleType = .scale) -> String {
    
        var dateString = self.dateSting(from: unixTime, formatter: format.formatString(scaleType))
        
        if YWUserManager.isENMode() {

            var monthArray = dateString.components(separatedBy: " ")
            if !monthArray.isEmpty, let monthIndex = Int(monthArray[0]), monthIndex >= 1 {
                monthArray[0] = YWDateHelper.enMonthName(monthIndex)
                dateString = monthArray.joined(separator: " ")
            }
        }
        
        return dateString
    }
    
    
    
    /// 将yyyyMMddHHmmss格式时间戳转化为时间通用样式
    /// - Parameters:
    ///   - dateString: yyyyMMddHHmmss格式时间
    ///   - format: 日期格式  参考YWCommonDateFormat
    ///   - showWeek: 是否展示 周   默认 false
    /// - Returns: 通用日期字符串
    @objc class func commonDateString(_ dateString: String, format: YWCommonDateFormat = .DF_MDY, scaleType: YWCommonDateScaleType = .scale, showWeek: Bool = false) -> String {
        
        var dateModel: YWDateModel = YWDateModel()
//        if showWeek {
//            dateModel = YXDateToolUtility.dateTimeAndWeek(withTime: dateString)
//        } else {
//            dateModel = YXDateToolUtility.dateTime(withTime: dateString)
//        }
    
        return self.commonDateModel(dateModel, format: format, scaleType: scaleType, showWeek: showWeek)
    }
    
    
    @objc class func commonDateStringWithNumber(_ dateValue: UInt64, format: YWCommonDateFormat = .DF_MDY, scaleType: YWCommonDateScaleType = .scale, showWeek: Bool = false) -> String {
        
        var dateModel: YWDateModel = YWDateModel()
//        if showWeek {
//            dateModel = YXDateToolUtility.dateTimeAndWeek(withTimeValue: TimeInterval(dateValue))
//        } else {
//            dateModel = YXDateToolUtility.dateTime(withTimeValue: TimeInterval(dateValue))
//        }
    
        return self.commonDateModel(dateModel, format: format, scaleType: scaleType, showWeek: showWeek)
    }

    
    @objc class func commonDateModel(_ dateModel: YWDateModel, format: YWCommonDateFormat = .DF_MDY, scaleType: YWCommonDateScaleType = .scale, showWeek: Bool = false) -> String {
        
        let year = dateModel.year
        var month = dateModel.month
        let day = dateModel.day
        let hour = dateModel.hour
        let minute = dateModel.minute
        let second = dateModel.second
        
        let scaleString = scaleType.scaleString
        
        var dateString = ""
        if YWUserManager.isENMode() {
            
            if let monthIndex = Int(month), monthIndex >= 1 {
                month = YWDateHelper.enMonthName(monthIndex)
            }
            switch format {
            case .DF_MD:
              
                dateString = day + " " + month

            case .DF_MDY:
                dateString = day + " " + month + ", " + year
                
            case .DF_MDYHM:
                dateString = day + " " + month + ", " + year + " " + hour + ":" + minute
                
            case .DF_MDYHMS:
                dateString = day + " " + month + ", " + year + " " + hour + ":" + minute + ":" + second
                
            case .DF_MDHM:
                dateString = day + " " + month + ", " + hour + ":" + minute
                
            case .DF_MDHMS:
                dateString = day + " " + month + ", " + hour + ":" + minute + ":" + second
            case .DF_MY:
                dateString = month + ", " + year
            }
        } else {
            switch format {
            case .DF_MD:
              
                dateString = month + scaleString + day

            case .DF_MDY:
                dateString = year + scaleString + month + scaleString + day
                
            case .DF_MDYHM:
                dateString = year + scaleString + month + scaleString + day + " " + hour + ":" + minute
                
            case .DF_MDYHMS:
                dateString = year + scaleString + month + scaleString + day + " " + hour + ":" + minute + ":" + second
                
            case .DF_MDHM:
                dateString = month + scaleString + day + " " + hour + ":" + minute
                
            case .DF_MDHMS:
                dateString = month + scaleString + day + " " + hour + ":" + minute + ":" + second
            case .DF_MY:
                dateString = year + scaleString + month
            }
        }
        
        if showWeek {
            dateString = dateString + " " + dateModel.week
        }
            
        
        return dateString
        
    }
    
    class func dateStingFromString(from dateString: String, formatterStyle: YWDateFomatterStyle = .yyyyMM) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date: Date = dateFormatter.date(from: dateString) {
            
            //yyyy-MM-dd HH:mm:ss
            dateFormatter.dateFormat = formatterStyle.rawValue
            let dateString = dateFormatter.string(from: date as Date)
            return dateString
        }

        return ""  
    }
}


class YWDateModel: NSObject {
    var year:String = ""
    var month:String = ""
    var day:String = ""
    var hour:String = ""
    var minute:String = ""
    var second:String = ""
    var week:String = ""
}
