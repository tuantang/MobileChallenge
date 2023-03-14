//
//  Response.swift
//  Networking
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import Foundation

public struct Response<T: Codable>: Codable {
    public var search: T?
    public let totalResults: String?
    public let error: String?
    public let response: String?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
        case error = "Error"
    }
}
