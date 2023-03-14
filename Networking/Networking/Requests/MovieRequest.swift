//
//  MovieRequest.swift
//  Networking
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import Foundation
import RxSwift
import Models

public class MovieRequest {
    private let provider: APIService
    public init() {
        provider = APIService()
    }
    
    public func getMovies(keyword: String, page: Int) -> Observable<Response<[Movie]>> {
        return provider.request(MovieEndpoint.movie(keyword: keyword, page: page))
    }
}
