//
//  Endpoint.swift
//  Networking
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import Alamofire

protocol Endpoint: URLRequestConvertible {
    var headers: [String: CustomStringConvertible] { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: CustomStringConvertible]? { get }
}

extension Endpoint {
    
    var headers: [String: CustomStringConvertible] {
        return [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = APIConfiguration.shared.apiBaseURL
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        for (key, value) in headers {
            urlRequest.setValue(value as? String, forHTTPHeaderField: key)
        }
        
        var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
        
        if let parameters = parameters {
            components?.queryItems = parameters.keys.map { key in
                URLQueryItem(name: key, value: parameters[key]?.description)
            }
        }
        
        urlRequest.url = components?.url
        
        return urlRequest
    }
}
