//
//  YWThemesColors.swift
//  YWTigerkin
//
//  Created by odd on 3/24/23.
//

import UIKit

class YWThemesColors: NSObject {
    
    class var col_blackColor:UIColor {
        return AutoFitHexColor(lightHex: "#000000", darkHex: "#000000")

    }
    
    class var col_whiteColor:UIColor {
        return AutoFitHexColor(lightHex: "#111111", darkHex: "#111111")

    }
    
    class var col_blackWhiteColor:UIColor {
        return AutoFitHexColor(lightHex: "#111111", darkHex: "#000000")

    }
    class var col_999999:UIColor {
        return AutoFitHexColor(lightHex: "#999999", darkHex: "#1C1C1C")
    }
}
