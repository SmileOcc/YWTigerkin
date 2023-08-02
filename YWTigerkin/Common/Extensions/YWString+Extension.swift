//
//  YWString+Extension.swift
//  YWTigerkin
//
//  Created by odd on 3/14/23.
//

import Foundation

func kIsEmpty(_ obj:Any?) -> Bool {
    if let objstr = obj as? String{
        return objstr.isEmpty
    }
    if let objstr = obj as? NSString {
        return objstr.length > 0 ? false : true
    }
    return true
}

func kIsNotEmpty(_ obj:Any?) -> Bool {
    return !kIsEmpty(obj)
}

extension String.Encoding{
    public static let gbk: String.Encoding = .init(rawValue:CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
}

//extension String.Encoding{
//    public static let gbk: String.Encoding = .init(rawValue: 2147485234)
//}
// MARK: - 一：字符串基本的扩展
public extension String {
    
    init?(gbkData: Data) {
            //获取GBK编码, 使用GB18030是因为它向下兼容GBK
            let cfEncoding = CFStringEncodings.GB_18030_2000
            let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
            //从GBK编码的Data里初始化NSString, 返回的NSString是UTF-16编码
            if let str = NSString(data: gbkData, encoding: encoding) {
                self = str as String
            } else {
                return nil
            }
        }
        
        var gbkData: Data {
            let cfEncoding = CFStringEncodings.GB_18030_2000
            let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
            let gbkData = (self as NSString).data(using: encoding)!
            return gbkData
        }
    
    
    // MARK: 1.1、字符串的长度
    
    //字符长度
    var kLenght: Int {
        return self.utf8.count
    }
    /// 字符串的长度（个数）
    var length: Int {
        let string = self
        return string.count
    }
    
    // MARK: 1.2、判断是否包含某个子串
    /// 判断是否包含某个子串
    /// - Parameter find: 子串
    /// - Returns: Bool
    func contains(find: String) -> Bool {
        return (self).range(of: find) != nil
    }
    
    // MARK: 1.3、判断是否包含某个子串 -- 忽略大小写
    ///  判断是否包含某个子串 -- 忽略大小写
    /// - Parameter find: 子串
    /// - Returns: Bool
    func containsIgnoringCase(find: String) -> Bool {
        return (self).range(of: find, options: .caseInsensitive) != nil
    }
    
    // MARK: 1.4、字符串转 base64
    /// 字符串 Base64 编码
    var base64Encode: String? {
        guard let codingData = (self).data(using: .utf8) else {
            return nil
        }
        return codingData.base64EncodedString()
    }
    // MARK: 1.5、base64转字符串转
    /// 字符串 Base64 编码
    var base64Decode: String? {
        guard let decryptionData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return String(data: decryptionData, encoding: .utf8)
    }
    
    // MARK: 1.6、将16进制字符串转为Int
    /// 将16进制字符串转为Int
    var hexInt: Int {
        return Int(self, radix: 16) ?? 0
    }
    
    // MARK: 1.7、判断是不是九宫格键盘
    /// 判断是不是九宫格键盘
    func isNineKeyBoard() -> Bool {
        let other: NSString = "➋➌➍➎➏➐➑➒"
        let len = (self).count
        for _ in 0..<len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        return true
    }
    
    // MARK: 1.8、字符串转 UIViewController
    /// 字符串转 UIViewController
    /// - Returns: 对应的控制器
    @discardableResult
    func toViewController() -> UIViewController? {
        // 1.获取类
        guard let trueClass: AnyClass = self.toClass() else {
            return nil
        }
        // 2.通过类创建对象
        // 2.1、将AnyClass 转化为指定的类
        guard let vcClass = trueClass as? UIViewController.Type else {
            return nil
        }
        // 2.2、通过class创建对象
        let vc = vcClass.init()
        return vc
    }
    
    // MARK: 1.9、字符串转 AnyClass
    /// 字符串转 AnyClass
    /// - Returns: 对应的 Class
    @discardableResult
    func toClass() -> AnyClass? {
        // 1.动态获取命名空间
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        // 2.将字符串转换为类
        // 2.1.默认情况下命名空间就是项目的名称，但是命名空间的名称是可以更改的
        guard let Class: AnyClass = NSClassFromString(namespace.removeSomeStringUseSomeString(removeString: " ", replacingString: "_") + "." + (self)) else {
            return nil
        }
        return Class
    }
    
    // MARK: 1.10、字符串转数组
    /// 字符串转数组
    /// - Returns: 转化后的数组
    func toArray() -> Array<Any> {
        let a = Array(self)
        return a
    }
    
    // MARK: 1.11、JSON 字符串 ->  Dictionary
    /// JSON 字符串 ->  Dictionary
    /// - Returns: Dictionary
    func jsonStringToDictionary() -> Dictionary<String, Any>? {
        let jsonString = self.self
        let jsonData: Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return (dict as! Dictionary<String, Any>)
        }
        return nil
    }
    
    // MARK: 1.12、JSON 字符串 -> Array
    /// JSON 字符串 ->  Array
    /// - Returns: Array
    func jsonStringToArray() -> Array<Any>? {
        let jsonString = self.self
        let jsonData:Data = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return (array as! Array<Any>)
        }
        return nil
    }
    
    /// Data转字符串/JSON字符串
    static func DataToJSONString(_ data: Data) -> String? {
        let jsonString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return jsonString
    }
    
    /// 字符串/JSON字符串转Data
    static func JSONStringToData(_ jsonString: String) -> Data? {
        let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        return data
    }
    /// 字典/数组转JSON字符串
    static func ObjectToJSONString(_ object: Any) -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: object, options: [])
            let jsonString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return jsonString
        } catch {
            print(error)
        }
        return nil
    }
    
    /// JSON字符串转字典/数组
    static func JSONStringToObject(_ jsonString: String) -> Any? {
        let jsonData: Data = jsonString.data(using: .utf8)!
        let object = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return object
    }
    
    /// 字典/数组转Data
    static func ObjectToData(_ object: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: object, options: [])
        } catch {
            print(error)
        }
        return nil
    }
    
    /// Data转字典/数组
    static func DataToObject(_ data: Data) -> Any? {
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            return object
        } catch {
            print(error)
        }
        return nil
    }
    
    /// Data转UIImage
    static func DataToUIImage(_ data: Data) -> UIImage? {
        let image = UIImage(data: data)
        return image
    }
    
    /// UIImage转Data
    static func UIImageToData(_ image: UIImage) -> Data? {
        //let pngImageData = image.pngData()
        let jpegImageData = image.jpegData(compressionQuality: 1)
        return jpegImageData
    }


    // MARK: 1.13、转成拼音
    /// 转成拼音
    /// - Parameter isLatin: true：带声调，false：不带声调，默认 false
    /// - Returns: 拼音
    func toPinyin(_ isTone: Bool = false) -> String {
        let mutableString = NSMutableString(string: self.self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        if !isTone {
            // 不带声调
            CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        }
        return mutableString as String
    }
    
    // MARK: 1.14、提取首字母, "爱国" --> AG
    /// 提取首字母, "爱国" --> AG
    /// - Parameter isUpper:  true：大写首字母，false: 小写首字母，默认 true
    /// - Returns: 字符串的首字母
    func pinyinInitials(_ isUpper: Bool = true) -> String {
        let pinyin = toPinyin(false).components(separatedBy: " ")
        let initials = pinyin.compactMap { String(format: "%c", $0.cString(using:.utf8)![0]) }
        return isUpper ? initials.joined().uppercased() : initials.joined()
    }
    
    // MARK: 1.15、字符串根据某个字符进行分隔成数组
    /// 字符串根据某个字符进行分隔成数组
    /// - Parameter char: 分隔符
    /// - Returns: 分隔后的数组
    func separatedByString(with char: String) -> Array<String> {
        let arraySubstrings = (self).components(separatedBy: char)
        let arrayStrings: [String] = arraySubstrings.compactMap { "\($0)" }
        return arrayStrings
    }
    
    // MARK: 1.16、设备的UUID
    /// 设备的UUID
    static func stringWithUUID() -> String? {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let cfString = CFUUIDCreateString(kCFAllocatorDefault, uuid)
        return cfString as String?
    }
    
    // MARK: 1.17、复制
    /// 复制
    func copy() {
        UIPasteboard.general.string = (self.self)
    }
    
    // MARK: 1.18、提取出字符串中所有的URL链接
    /// 提取出字符串中所有的URL链接
    /// - Returns: URL链接数组
    func getUrls() -> [String]? {
        var urls = [String]()
        // 创建一个正则表达式对象
        guard let dataDetector = try? NSDataDetector(types:  NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue)) else {
            return nil
        }
        // 匹配字符串，返回结果集
        let res = dataDetector.matches(in: self.self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, (self.self).count))
        // 取出结果
        for checkingRes in res {
            urls.append((self as NSString).substring(with: checkingRes.range))
        }
        return urls
    }
    
    // MARK: 1.19、String或者String HTML标签转富文本设置
    /// String 或者String HTML标签 转 html 富文本设置
    /// - Parameters:
    ///   - font: 设置字体
    ///   - lineSpacing: 设置行高
    /// - Returns: 默认不将 \n替换<br/> 返回处理好的富文本
    func setHtmlAttributedString(font: UIFont? = UIFont.systemFont(ofSize: 16), lineSpacing: CGFloat? = 10) -> NSMutableAttributedString {
        var htmlString: NSMutableAttributedString? = nil
        do {
            if let data = (self.self).replacingOccurrences(of: "\n", with: "<br/>").data(using: .utf8) {
                htmlString = try NSMutableAttributedString(data: data, options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                ], documentAttributes: nil)
                let wrapHtmlString = NSMutableAttributedString(string: "\n")
                // 判断尾部是否是换行符
                if let weakHtmlString = htmlString, weakHtmlString.string.hasSuffix("\n") {
                    htmlString?.deleteCharacters(in: NSRange(location: weakHtmlString.length - wrapHtmlString.length, length: wrapHtmlString.length))
                }
            }
        } catch {
        }
        // 设置富文本字的大小
        if let font = font {
            htmlString?.addAttributes([
                NSAttributedString.Key.font: font
            ], range: NSRange(location: 0, length: htmlString?.length ?? 0))
        }
        
        // 设置行间距
        if let weakLineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = weakLineSpacing
            htmlString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: htmlString?.length ?? 0))
        }
        return htmlString ?? NSMutableAttributedString(string: self.self)
    }
    
    // MARK: 1.20、计算字符个数（英文 = 1，数字 = 1，汉语 = 2）
    /// 计算字符个数（英文 = 1，数字 = 1，汉语 = 2）
    /// - Returns: 返回字符的个数
    func countOfChars() -> Int {
        var count = 0
        guard (self.self).count > 0 else { return 0 }
        for i in 0...(self.self).count - 1 {
            let c: unichar = ((self.self) as NSString).character(at: i)
            if (c >= 0x4E00) {
                count += 2
            } else {
                count += 1
            }
        }
        return count
    }
}
extension String {
    
    
    // MARK: 3.1、去除字符串前后的 空格
    /// 去除字符串前后的 空格
    var removeBeginEndAllSapcefeed: String {
        let resultString = self.trimmingCharacters(in: CharacterSet.whitespaces)
        return resultString
    }
    
    // MARK: 3.2、去除字符串前后的 换行
    /// 去除字符串前后的 换行
    var removeBeginEndAllLinefeed: String {
        let resultString = self.trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }
    
    // MARK: 3.3、去除字符串前后的 换行和空格
    /// 去除字符串前后的 换行和空格
    var removeBeginEndAllSapceAndLinefeed: String {
        var resultString = self.trimmingCharacters(in: CharacterSet.whitespaces)
        resultString = resultString.trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }
    
    // MARK: 3.4、去掉所有空格
    /// 去掉所有空格
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    // MARK: 3.5、去掉所有换行
    /// 去掉所有换行
    var removeAllLinefeed: String {
        return self.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil)
    }
    
    // MARK: 3.6、去掉所有空格 和 换行
    /// 去掉所有的空格 和 换行
    var removeAllLineAndSapcefeed: String {
        // 去除所有的空格
        var resultString = self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        // 去除所有的换行
        resultString = resultString.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil)
        return resultString
    }
    
    // MARK: 3.7、是否是 0-9 的数字，也不包含小数点
    /// 是否是 0-9 的数字，也不包含小数点
    /// - Returns: 结果
    func isValidNumber() -> Bool {
        /// 0-9的数字，也不包含小数点
        let rst: String = self.trimmingCharacters(in: .decimalDigits)
        if rst.count > 0 {
            return false
        }
        return true
    }
    
    // MARK: 3.8、url进行编码
    /// url 进行编码
    /// - Returns: 返回对应的URL
    func urlEncode() -> String {
        // 为了不把url中一些特殊字符也进行转换(以%为例)，自己添加到自付集中
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "%")
        return self.addingPercentEncoding(withAllowedCharacters: charSet) ?? ""
    }
    
    // MARK: 3.9、url进行解码
    /// url解码
    func urlDecode() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    // MARK: 3.10、某个字符使用某个字符替换掉
    /// 某个字符使用某个字符替换掉
    /// - Parameters:
    ///   - removeString: 原始字符
    ///   - replacingString: 替换后的字符
    /// - Returns: 替换后的整体字符串
    func removeSomeStringUseSomeString(removeString: String, replacingString: String = "") -> String {
        return self.replacingOccurrences(of: removeString, with: replacingString)
    }
    
    //MARK: 3.11、字符串指定range替换
    /// 字符串指定range替换
    /// - Parameters:
    ///   - range: range
    ///   - replacingString: 指定范围内新的字符串
    /// - Returns: 返回新的字符串
    func replacingCharacters(range: NSRange, replacingString: String = "") -> String {
        return (self as NSString).replacingCharacters(in: range, with: replacingString)
    }
    
    // MARK: 3.12、使用正则表达式替换某些子串
    /// 使用正则表达式替换
    /// - Parameters:
    ///   - pattern: 正则
    ///   - with: 用来替换的字符串
    ///   - options: 策略
    /// - Returns: 返回替换后的字符串
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
    // MARK: 3.13、删除指定的字符
    /// 删除指定的字符
    /// - Parameter characterString: 指定的字符
    /// - Returns: 返回删除后的字符
    func removeCharacter(characterString: String) -> String {
        let characterSet = CharacterSet(charactersIn: characterString)
        return self.trimmingCharacters(in: characterSet)
    }
    
    //处理标签中包含 p 标签换行(独占一行)的问题
    func tttt() {
        var htmlString:NSMutableAttributedString?
        let wrapHtmlString = NSMutableAttributedString(string: "\n")
         // 判断尾部是否是换行符
        if let weakHtmlString = htmlString, weakHtmlString.string.hasSuffix("\n") {
              htmlString?.deleteCharacters(in: NSRange(location: weakHtmlString.length - wrapHtmlString.length, length: wrapHtmlString.length))
        }
    }
    
    func htmlSize() {
        let strHtml = "<p style='color:green'>首付<span style='color:#e83c36;'>5000元</span>，提前付<span style='color:red'>3倍月供</span>，月供<span style='color:red'>3000元</span>(48期)</p>"
        let attributedText = strHtml.setHtmlAttributedString(font: UIFont.systemFont(ofSize: 20), lineSpacing: 10)
        let textSize = attributedText.boundingRect(with: CGSize(width: KSCREEN_WIDTH - 40, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
    }
    /// String 或者String HTML标签 转 html 富文本设置
    /// - Parameters:
    ///   - font: 设置字体
    ///   - lineSpacing: 设置行高
    /// - Returns: 默认不将 \n替换<br/> 返回处理好的富文本
//    func setHtmlAttributedString(font: UIFont? = UIFont.systemFont(ofSize: 16), lineSpacing: CGFloat? = 10) -> NSMutableAttributedString {
//        var htmlString: NSMutableAttributedString? = nil
//        do {
//            if let data = self.replacingOccurrences(of: "\n", with: "<br/>").data(using: .utf8) {
//                htmlString = try NSMutableAttributedString(data: data, options: [
//                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
//                NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
//                let wrapHtmlString = NSMutableAttributedString(string: "\n")
//                // 判断尾部是否是换行符
//                if let weakHtmlString = htmlString, weakHtmlString.string.hasSuffix("\n") {
//                    htmlString?.deleteCharacters(in: NSRange(location: weakHtmlString.length - wrapHtmlString.length, length: wrapHtmlString.length))
//                }
//            }
//        } catch {
//        }
//        // 设置富文本字的大小
//        if let font = font {
//            htmlString?.addAttributes([
//            NSAttributedString.Key.font: font], range: NSRange(location: 0, length: htmlString?.length ?? 0))
//        }
//
//        // 设置行间距
//        if let weakLineSpacing = lineSpacing {
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = weakLineSpacing
//            htmlString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: htmlString?.length ?? 0))
//        }
//        return htmlString ?? NSMutableAttributedString(string: self)
//    }
}

//swift上的该方法对于第三方键盘上的部分表情判断也没办法做到百分百准确。
extension String {
    /// 方法三
    var ywIsSingleEmoji : Bool {
        if self.count == 1 {
            let emodjiGlyphPattern = "\\p{RI}{2}|(\\p{Emoji}(\\p{EMod}|\\x{FE0F}\\x{20E3}?|[\\x{E0020}-\\x{E007E}]+\\x{E007F})|[\\p{Emoji}&&\\p{Other_symbol}])(\\x{200D}(\\p{Emoji}(\\p{EMod}|\\x{FE0F}\\x{20E3}?|[\\x{E0020}-\\x{E007E}]+\\x{E007F})|[\\p{Emoji}&&\\p{Other_symbol}]))*"

            let fullRange = NSRange(location: 0, length: self.utf16.count)
            if let regex = try? NSRegularExpression(pattern: emodjiGlyphPattern, options: .caseInsensitive) {
                let regMatches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(), range: fullRange)
                if regMatches.count > 0 {
                    // if any range found — it means, that that single character is emoji
                    return true
                }
            }
        }
        return false
    }
    
    // 最好一二一起
    // 方法一
    var ywContainsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons 128512...128591
                0x1F300...0x1F5FF, // Misc Symbols and Pictographs 127744...128511
                0x1F680...0x1F6FF, // Transport and Map 128640...128767
                0x2600...0x26FF,   // Misc symbols 9728...9983
                0x2700...0x27BF,   // Dingbats  9984...10175
                0xFE00...0xFE0F,   // Variation Selectors   65024... 65039
                0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs 129280 - 129535
                0x1F1E6...0x1F1FF, // Flags 127462...127487
                0x1F018...0x1F270, // Various asian characters           127000...127600
                8400...8447,  // Combining Diacritical Marks for Symbols
                9100...9300, // // Misc items
                127000...127600:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// 方法二
    /// 是否为单个emoji表情
    var isSingleEmoji: Bool {
        return count==1&&containsEmoji
    }

    /// 包含emoji表情
    var containsEmoji: Bool {
        return contains{ $0.isEmoji}
    }

    /// 只包含emoji表情
    var containsOnlyEmoji: Bool {
        return !isEmpty && !contains{!$0.isEmoji}
    }

    /// 提取emoji表情字符串
    var emojiString: String {
        return emojis.map{String($0) }.reduce("",+)
    }

    /// 提取emoji表情数组
    var emojis: [Character] {
        return filter{ $0.isEmoji}
    }

    /// 提取单元编码标量
    var emojiScalars: [UnicodeScalar] {
        return filter{ $0.isEmoji}.flatMap{ $0.unicodeScalars}
    }
}

extension Character {
    /// 简单的emoji是一个标量，以emoji的形式呈现给用户
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else {
            return false
        }
        return unicodeScalars.count == 1 &&
            (firstProperties.isEmojiPresentation ||
                firstProperties.generalCategory == .otherSymbol)
    }

    /// 检查标量是否将合并到emoji中
    var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 1 &&
            unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }

    /// 是否为emoji表情
    /// - Note: http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    var isEmoji: Bool {
        return isSimpleEmoji || isCombinedIntoEmoji
    }
}

// MARK: - 四、字符串的转换
extension  String {
    
    // MARK: 4.1、字符串 转 CGFloat
    /// 字符串 转 Float
    /// - Returns: CGFloat
    func toCGFloat() -> CGFloat? {
        if let doubleValue = Double(self) {
            return CGFloat(doubleValue)
        }
        return nil
    }
    
    // MARK: 4.2、字符串转 Bool
    /// 字符串转 Bool
    /// - Returns: Bool
    func toBool() -> Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
    
    // MARK: 4.3、字符串转 Int
    /// 字符串转 Int
    /// - Returns: Int
    func toInt() -> Int {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return 0
        }
    }
    
    // MARK: 4.4、字符串转 Double
    /// 字符串转 Double
    /// - Returns: Double
    func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    // MARK: 4.5、字符串转 Float
    /// 字符串转 Float
    /// - Returns: Float
    func toFloat() -> Float {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return 0.0
        }
    }
    
    // MARK: 4.6、字符串转 NSString
    /// 字符串转 NSString
    var toNSString: NSString {
        return self as NSString
    }
    
    // MARK: 4.7、字符串转 Int64
    /// 字符串转 Int64
    var toInt64Value: Int64? {
        return Int64(self)
    }
    
}

// MARK: - 九、字符串的一些正则校验
extension String {
    
    // MARK: 9.1、判断是否全是空白,包括空白字符和换行符号，长度为0返回true
    /// 判断是否全是空白,包括空白字符和换行符号，长度为0返回true
    public var isBlank: Bool {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == ""
    }
    
    // MARK: 9.2、判断是否全十进制数字，长度为0返回false
    /// 判断是否全十进制数字，长度为0返回false
    public var isDecimalDigits: Bool {
        if self.isEmpty {
            return false
        }
        // 去除什么的操作
        return self.trimmingCharacters(in: NSCharacterSet.decimalDigits) == ""
    }
    
    // MARK: 9.3、判断是否是整数
    /// 判断是否是整数
    public var isPureInt: Bool {
        let scan: Scanner = Scanner(string: self)
        var n: Int = 0
        return scan.scanInt(&n) && scan.isAtEnd
    }
    
    // MARK: 9.4、判断是否是Float,此处Float是包含Int的，即Int是特殊的Float
    /// 判断是否是Float，此处Float是包含Int的，即Int是特殊的Float
    public var isPureFloat: Bool {
        let scan: Scanner = Scanner(string: self)
        var n: Float = 0.0
        return scan.scanFloat(&n) && scan.isAtEnd
    }
    
    // MARK: 9.5、判断是否全是字母，长度为0返回false
    /// 判断是否全是字母，长度为0返回false
    public var isLetters: Bool {
        if self.isEmpty {
            return false
        }
        return self.trimmingCharacters(in: NSCharacterSet.letters) == ""
    }
    
    // MARK: 9.6、判断是否是中文, 这里的中文不包括数字及标点符号
    /// 判断是否是中文, 这里的中文不包括数字及标点符号
    public var isChinese: Bool {
        let rgex = "(^[\u{4e00}-\u{9fef}]+$)"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 9.7、是否是有效昵称，即允许“中文”、“英文”、“数字”
    /// 是否是有效昵称，即允许“中文”、“英文”、“数字”
    public var isValidNickName: Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 9.8、判断是否是有效的手机号码
    /// 判断是否是有效的手机号码
    public var isValidMobile: Bool {
        let rgex = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199)\\d{8}$"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 9.9、判断是否是有效的电子邮件地址
    /// 判断是否是有效的电子邮件地址
    public var isValidEmail: Bool {
        let rgex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 9.10、判断是否有效的身份证号码，不是太严格
    /// 判断是否有效的身份证号码，不是太严格
    public var isValidIDCardNumber: Bool {
        let rgex = "^(\\d{15})|((\\d{17})(\\d|[X]))$"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 9.11、严格判断是否有效的身份证号码,检验了省份，生日，校验位，不过没检查市县的编码
    /// 严格判断是否有效的身份证号码,检验了省份，生日，校验位，不过没检查市县的编码
    public var isValidIDCardNumStrict: Bool {
        let str = self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let len = str.count
        if !str.isValidIDCardNumber {
            return false
        }
        // 省份代码
        let areaArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        if !areaArray.contains(str.sub(to: 2)) {
            return false
        }
        var regex = NSRegularExpression()
        var numberOfMatch = 0
        var year = 0
        switch len {
        case 15:
            // 15位身份证
            // 这里年份只有两位，00被处理为闰年了，对2000年是正确的，对1900年是错误的，不过身份证是1900年的应该很少了
            year = Int(str.sub(start: 6, length: 2))!
            if isLeapYear(year: year) { // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, len))
            
            if numberOfMatch > 0 {
                return true
            } else {
                return false
            }
        case 18:
            // 18位身份证
            year = Int(str.sub(start: 6, length: 4))!
            if isLeapYear(year: year) {
                // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, len))
            if numberOfMatch > 0 {
                var s = 0
                let jiaoYan = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3]
                for i in 0 ..< 17 {
                    if let d = Int(str.slice(i ..< (i + 1))) {
                        s += d * jiaoYan[i % 10]
                    } else {
                        return false
                    }
                }
                let Y = s % 11
                let JYM = "10X98765432"
                let M = JYM.sub(start: Y, length: 1)
                if M == str.sub(start: 17, length: 1) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    // MARK: 9.12、校验字符串位置是否合理，并返回String.Index
    /// 校验字符串位置是否合理，并返回String.Index
    /// - Parameter original: 位置
    /// - Returns: String.Index
    public func validIndex(original: Int) -> String.Index {
        switch original {
        case ...self.startIndex.utf16Offset(in: self):
            return self.startIndex
        case self.endIndex.utf16Offset(in: self)...:
            return self.endIndex
        default:
            return self.index(self.startIndex, offsetBy: original > self.count ? self.count : original)
        }
    }
    
    // MARK: 9.13、隐藏手机号中间的几位
    /// 隐藏手机号中间的几位
    /// - Parameter combine: 隐藏的字符串(替换的类型)
    /// - Returns: 返回隐藏的手机号
    public func hide12BitsPhone(combine: String = "****") -> String {
        if self.count >= 11 {
            let pre = self.sub(start: 0, length: 3)
            let post = self.sub(start: 7, length: 4)
            return pre + combine + post
        } else {
            return self
        }
    }
    
    // MARK: 9.14、隐藏手机号中间的几位(保留前几位和后几位)
    /// 隐藏手机号中间的几位(保留前几位和后几位)
    /// - Parameters:
    ///   - combine: 中间加密的符号
    ///   - digitsBefore: 前面保留的位数
    ///   - digitsAfter: 后面保留的位数
    /// - Returns: 返回隐藏的手机号
    public func hidePhone(combine: String = "*", digitsBefore: Int = 2, digitsAfter: Int = 2) -> String {
        let phoneLength: Int = self.count
        if phoneLength > digitsBefore + digitsAfter {
            let combineCount: Int = phoneLength - digitsBefore - digitsAfter
            var combineContent: String = ""
            for _ in 0..<combineCount {
                combineContent = combineContent + combine
            }
            let pre = self.sub(start: 0, length: digitsBefore)
            let post = self.sub(start: phoneLength - digitsAfter, length: digitsAfter)
            return pre + "\(combineContent)" + post
        } else {
            return self
        }
    }
    
    // MARK: 9.15、隐藏邮箱中间的几位(保留前几位和后几位)
    /// 隐藏邮箱中间的几位(保留前几位和后几位)
    /// - Parameters:
    ///   - combine: 加密的符号
    ///   - digitsBefore: 前面保留几位
    ///   - digitsAfter: 后面保留几位
    /// - Returns: 返回加密后的字符串
    public func hideEmail(combine: String = "*", digitsBefore: Int = 1, digitsAfter: Int = 1) -> String {
        let emailArray = self.separatedByString(with: "@")
        if emailArray.count == 2 {
            let fistContent = emailArray[0]
            let encryptionContent = fistContent.hidePhone(combine: "*", digitsBefore: 1, digitsAfter: 1)
            return encryptionContent + "@" +  emailArray[1]
        }
        return self
    }
    
    // MARK: 9.16、检查字符串是否有特定前缀：hasPrefix
    /// 检查字符串是否有特定前缀：hasPrefix
    /// - Parameter prefix: 前缀字符串
    /// - Returns: 结果
    public func isHasPrefix(prefix: String) -> Bool {
        return self.hasPrefix(prefix)
    }
    
    // MARK: 9.17、检查字符串是否有特定后缀：hasSuffix
    /// 检查字符串是否有特定后缀：hasSuffix
    /// - Parameter suffix: 后缀字符串
    /// - Returns: 结果
    public func isHasSuffix(suffix: String) -> Bool {
        return self.hasSuffix(suffix)
    }
    
    // MARK: 9.18、是否为0-9之间的数字(字符串的组成是：0-9之间的数字)
    /// 是否为0-9之间的数字(字符串的组成是：0-9之间的数字)
    /// - Returns: 返回结果
    public func isValidNumberValue() -> Bool {
        guard self.count > 0 else {
            return false
        }
        let rgex = "^[\\d]*$"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 9.19、是否为数字或者小数点(字符串的组成是：0-9之间的数字或者小数点即可)
    /// 是否为数字或者小数点(字符串的组成是：0-9之间的数字或者小数点即可)
    /// - Returns: 返回结果
    public func isValidNumberAndDecimalPoint() -> Bool {
        guard self.count > 0 else {
            return false
        }
        let rgex = "^[\\d.]*$"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 9.20、验证URL格式是否正确
    /// 验证URL格式是否正确
    /// - Returns: 结果
    public func verifyUrl() -> Bool {
        // 创建NSURL实例
        if let url = URL(string: self) {
            //检测应用是否能打开这个NSURL实例
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    // MARK: 9.21、是否是一个有效的文件URL, "file://Documents/file.txt".isValidFileUrl -> true
    /// 是否是一个有效的文件URL
    public var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
    
    // MARK: 9.22、富文本匹配(某些关键词高亮)
    /// 富文本匹配(某些关键词高亮)
    /// - Parameters:
    ///   - substring: 匹配的关键字
    ///   - normalColor: 常规的颜色
    ///   - highlightedCololor: 关键字的颜色
    ///   - isSplit: 是否分隔匹配
    ///   - options: 匹配规则
    /// - Returns: 返回匹配后的富文本
    public func stringWithHighLightSubstring(keyword: String, font: UIFont, normalColor: UIColor, keywordCololor: UIColor, isSplit: Bool = false, options: NSRegularExpression.Options = []) -> NSMutableAttributedString {
        let totalString = self
        let attributedString = NSMutableAttributedString(string: totalString)
        attributedString.addAttributes([.foregroundColor: normalColor, .font: font], range: NSRange(location: 0, length: totalString.count))
        if isSplit {
            for i in 0..<keyword.count {
                let singleString = keyword.sub(start: i, length: 1)
                let ranges = JKRegexHelper.matchRange(totalString, pattern: singleString)
                for range in ranges {
                    attributedString.addAttributes([.foregroundColor: keywordCololor, .font: font], range: range)
                }
            }
        } else {
            let ranges = JKRegexHelper.matchRange(totalString, pattern: keyword)
            for range in ranges {
                attributedString.addAttributes([.foregroundColor: keywordCololor, .font: font], range: range)
            }
        }
        return attributedString
    }
    
    //MARK: 9.23、判断是否是视频链接
    /// 判断是否是视频链接
    public var isVideoUrl: Bool {
        let videoUrls = ["mp4", "MP4", "MOV", "mov", "mpg", "mpeg", "mpg4", "wm", "wmx", "mkv", "mkv2", "3gp", "3gpp", "wv", "wvx", "avi", "asf", "fiv", "swf", "flv", "f4v", "m4u", "m4v", "mov", "movie", "pvx", "qt", "rv", "vod", "rm", "ram", "rmvb"]
        return videoUrls.contains { self.hasSuffix($0) }
    }
    
    // MARK: - private 方法
    // MARK: 是否是闰年
    /// 是否是闰年
    /// - Parameter year: 年份
    /// - Returns: 返回是否是闰年
    private func isLeapYear(year: Int) -> Bool {
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    private func predicateValue(rgex: String) -> Bool {
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", rgex)
        return checker.evaluate(with: self)
    }
}

// MARK: - 十、字符串截取的操作
extension String {
    
    // MARK: 10.1、截取字符串从开始到 index
    /// 截取字符串从开始到 index
    /// - Parameter index: 截取到的位置
    /// - Returns: 截取后的字符串
    public func sub(to index: Int) -> String {
        let end_Index = validIndex(original: index)
        return String(self[self.startIndex ..< end_Index])
    }
    
    // MARK: 10.2、截取字符串从index到结束
    /// 截取字符串从index到结束
    /// - Parameter index: 截取结束的位置
    /// - Returns: 截取后的字符串
    public func sub(from index: Int) -> String {
        let start_index = validIndex(original: index)
        return String(self[start_index ..< self.endIndex])
    }
    
    // MARK: 10.3、获取指定位置和长度的字符串
    /// 获取指定位置和大小的字符串
    /// - Parameters:
    ///   - start: 开始位置
    ///   - length: 长度
    /// - Returns: 截取后的字符串
    public func sub(start: Int, length: Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(self.startIndex, offsetBy: start)
        let en = self.index(st, offsetBy: len)
        let range = st ..< en
        return String(self[range]) // .substring(with:range)
    }
    
    // MARK: 10.4、切割字符串(区间范围 前闭后开)
    /**
     CountableClosedRange：可数的闭区间，如 0...2
     CountableRange：可数的开区间，如 0..<2
     ClosedRange：不可数的闭区间，如 0.1...2.1
     Range：不可数的开居间，如 0.1..<2.1
     */
    /// 切割字符串(区间范围 前闭后开)
    /// - Parameter range: 范围
    /// - Returns: 切割后的字符串
    public func slice(_ range: CountableRange<Int>) -> String {
        // 如 slice(2..<6)
        /**
         upperBound（上界）
         lowerBound（下界）
         */
        let startIndex = validIndex(original: range.lowerBound)
        let endIndex = validIndex(original: range.upperBound)
        guard startIndex < endIndex else {
            return ""
        }
        return String(self[startIndex ..< endIndex])
    }
    
    // MARK: 10.5、子字符串第一次出现的位置
    /// 子字符串第一次出现的位置
    /// - Parameter sub: 子字符串
    /// - Returns: 返回字符串的位置（如果内部不存在该字符串则返回 -1）
    public func positionFirst(of sub: String) -> Int {
        return position(of: sub)
    }
    
    // MARK: 10.6、子字符串最后一次出现的位置
    /// 子字符串第一次出现的位置
    /// - Parameter sub: 子字符串
    /// - Returns: 返回字符串的位置（如果内部不存在该字符串则返回 -1）
    public func positionLast(of sub: String) -> Int {
        return position(of: sub, backwards: true)
    }
    
    /// 返回(第一次/最后一次)出现的指定子字符串在此字符串中的索引，如果内部不存在该字符串则返回 -1
    /// - Parameters:
    ///   - sub: 子字符串
    ///   - backwards: 如果backwards参数设置为true，则返回最后出现的位置
    /// - Returns: 位置
    private func position(of sub: String, backwards: Bool = false) -> Int {
        var pos = -1
        if let range = self.range(of: sub, options: backwards ? .backwards : .literal) {
            if !range.isEmpty {
                pos = self.distance(from: self.startIndex, to: range.lowerBound)
            }
        }
        return pos
    }
    
    // MARK: 10.7、获取某个位置的字符串
    /// 获取某个位置的字符串
    /// - Parameter index: 位置
    /// - Returns: 某个位置的字符串
    public func indexString(index: Int) -> String  {
        return slice((index ..< index + 1))
    }
    
    // MARK: 10.8、获取某个子串在父串中的范围->Range
    /// 获取某个子串在父串中的范围->Range
    /// - Parameter str: 子串
    /// - Returns: 某个子串在父串中的范围
    public func ywRange(of subString: String) -> Range<String.Index>? {
        return self.range(of: subString)
    }
    
    // MARK: 10.9、获取某个子串在父串中的范围->[NSRange]
    /// 获取某个子串在父串中的范围->NSRange
    /// - Parameter str: 子串
    /// - Returns: 某个子串在父串中的范围
    public func nsRange(of subString: String) -> [NSRange] {
        guard self.contains(find: subString) else {
            return []
        }
        // return text.range(of: subString)
        return JKRegexHelper.matchRange(self, pattern: subString)
    }
    
    // MARK: 10.10、在任意位置后面插入字符串
    /// 在任意位置后面插入字符串
    /// - Parameters:
    ///   - content: 插入内容
    ///   - locat: 插入的位置
    /// - Returns: 添加后的字符串
    public func insertString(content: String, locat: Int) -> String {
        guard locat < self.count && locat > 0  else {
            return locat <= 0 ? (content + self) : (self + content)
        }
        let str1 = self.sub(to: locat)
        let str2 = self.sub(from: locat)
        return str1 + content + str2
    }
    
    //MARK: 10.11、匹配两个字符之间的内容
    /// 匹配两个字符之间的内容
    /// - Parameters:
    ///   - leftChar: 左边的字符
    ///   - rightChar: 右边的字符
    /// - Returns: 匹配后的字符串数组
    public func matchesMiddleContentOfCharacters(leftChar: String, rightChar: String) -> [String] {
        do {
            let pattern: String = "(?<=\\\(leftChar)).*?(?=\\\(rightChar))"
            /// 最初的额正则
            // let pattern: ·String = "(?<=\\[).*?(?=\\])"
            // let pattern: String = "(\\\(leftChar)[^\\]]*\\\(rightChar))"
            let regex = try NSRegularExpression(pattern: pattern)
            let nsString = self.toNSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map {
                nsString.substring(with: $0.range)
                // self.jk.sub(start: $0.range.location, length: $0.range.length)
                // String(nsString.substring(with: $0.range(at: 1)).dropFirst().dropLast())
            }
        } catch let error {
            debugPrint("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    //MARK: - 其他
    func md5cc() -> String {
        
        if #available(iOS 13.0, *) {
            return  self.map { String(format: "%02x", $0 as! CVarArg) }.joined()
        }
        
        let cStrl = cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
        
        
        var md5String = "";
        for idx in 0...15 {
            let obcStrl = String.init(format: "%02x", buffer[idx]);
            md5String.append(obcStrl);
        }
        free(buffer);
        return md5String;
        
    }
    
    func urlScheme(scheme:String) -> URL? {
        if let url = URL.init(string: self) {
            var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
            components?.scheme = scheme
            return components?.url
        }
        return nil
    }
    
    static func format(decimal:Float, _ maximumDigits:Int = 1, _ minimumDigits:Int = 1) ->String? {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumDigits //设置小数点后最多2位
        numberFormatter.minimumFractionDigits = minimumDigits //设置小数点后最少2位（不足补0）
        return numberFormatter.string(from: number)
    }
    
    static func formatCount(count:NSInteger) -> String {
        if count < 10000  {
            return String.init(count)
        } else {
            return (String.format(decimal: Float(count)/Float(10000)) ?? "0") + "w"
        }
    }
    
    func singleLineSizeWithText(font:UIFont) -> CGSize {
        return self.size(withAttributes: [NSAttributedString.Key.font : font])
    }
    
    func singleLineSizeWithAttributeText(font:UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font:font]
        let attString = NSAttributedString(string: self,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude), nil)
    }
}
