//
//  NetworkLogger.swift
//  Networking
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import Alamofire

class NetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "com.tuantang.Networking")
    
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    func request<Value>(_ request: DataRequest, didParseReponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else { return }
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print(json)
        }
    }
}
