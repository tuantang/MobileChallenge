//
//  APIConfiguration.swift
//  Networking
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import Foundation

class APIConfiguration {
    
    public static var shared: APIConfiguration = APIConfiguration()
    private init() {}
    
    var apiBaseURL: URL {
        let bundle = Bundle(identifier: "com.tuantang.Networking")
        guard let apiBaseURL = bundle?.object(forInfoDictionaryKey: "APIBaseURL") as? String else {
            fatalError("APIBaseURL must not be empty in plist")
        }
        return URL(string: apiBaseURL)!
    }
    
    var apiKey: URL {
        let bundle = Bundle(identifier: "com.tuantang.Networking")
        guard let apiKey = bundle?.object(forInfoDictionaryKey: "APIKey") as? String else {
            fatalError("APIKey must not be empty in plist")
        }
        return URL(string: apiKey)!
    }
}

enum ContentType: String {
    case json = "Application/json"
    case formEncode = "application/x-www-form-urlencoded"
    
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case string = "String"
}
