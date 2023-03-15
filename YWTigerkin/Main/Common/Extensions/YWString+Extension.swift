//
//  YWString+Extension.swift
//  YWTigerkin
//
//  Created by odd on 3/14/23.
//

import Foundation

extension String {
    
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
    func setHtmlAttributedString(font: UIFont? = UIFont.systemFont(ofSize: 16), lineSpacing: CGFloat? = 10) -> NSMutableAttributedString {
        var htmlString: NSMutableAttributedString? = nil
        do {
            if let data = self.replacingOccurrences(of: "\n", with: "<br/>").data(using: .utf8) {
                htmlString = try NSMutableAttributedString(data: data, options: [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
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
            NSAttributedString.Key.font: font], range: NSRange(location: 0, length: htmlString?.length ?? 0))
        }
    
        // 设置行间距
        if let weakLineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = weakLineSpacing
            htmlString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: htmlString?.length ?? 0))
        }
        return htmlString ?? NSMutableAttributedString(string: self)
    }
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
