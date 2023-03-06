//
//  YWResult.swift
//  YWTigerkin
//
//  Created by odd on 3/2/23.
//

import Foundation

public struct YWResult<C: Codable>: Codable {
    public let statusCode: Int
    public let message: String?
    public let result: C?
    
}

