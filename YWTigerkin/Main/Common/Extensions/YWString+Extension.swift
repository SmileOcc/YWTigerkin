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
