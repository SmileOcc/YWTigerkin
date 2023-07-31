//
//  YWNSattributedString+Extension.swift
//  YWTigerkin
//
//  Created by odd on 7/2/23.
//

import Foundation

extension NSAttributedString {
    func multiLineSize(width:CGFloat) -> CGSize {
        let rect = self.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return CGSize.init(width: rect.size.width, height: rect.size.height)
    }
}
