//
//  APIService.swift
//  Networking
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import Foundation
import Alamofire
import RxSwift


class APIService {
    
    let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        let networkLogger = NetworkLogger()
        return Session(configuration: configuration, eventMonitors: [networkLogger])
    }()
    
    func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.session.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 400:
                        observer.onError(APIError.badRequest)
                    case 401:
                        observer.onError(APIError.unauthorized)
                    case 403:
                        observer.onError(APIError.forbidden)
                    case 404:
                        observer.onError(APIError.notFound)
                    case 405:
                        observer.onError(APIError.noAllowed)
                    case 409:
                        observer.onError(APIError.conflict)
                    case 500:
                        observer.onError(APIError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            return Disposables.create {}
        }
    }
}
