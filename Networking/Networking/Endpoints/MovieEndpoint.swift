//
//  MovieEndpoint.swift
//  Networking
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import Alamofire

enum MovieEndpoint: Endpoint {

    case movie(keyword: String, page: Int)
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String : CustomStringConvertible]? {
        switch self {
        case .movie(let keyword, let page):
            return [
                "apikey": APIConfiguration.shared.apiKey,
                "s": keyword,
                "type": "movie",
                "page": page
            ]
        }
        
    }
    
}
