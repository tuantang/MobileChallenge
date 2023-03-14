//
//  MoviesViewModelType.swift
//  MobileChallenge-iOS
//
//  Created by Tuấn Tăng on 14/03/2023.
//

import RxSwift
import RxRelay
import RxCocoa
import Networking
import Models

protocol MoviesViewModelInput {
    var moviesRequest: PublishSubject<Void> { get }
    var nextMoviesRequest: PublishSubject<Void> { get }
}

protocol MoviesViewModelOutput {
    var element: BehaviorRelay<Response<[Movie]>?> { get }
    var isLoading: Driver<Bool> { get }
    var moreLoading: Driver<Bool> { get }
}

protocol MoviesViewModelType {
    var inputs: MoviesViewModelInput { get }
    var outputs: MoviesViewModelOutput { get }
}
