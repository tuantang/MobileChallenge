//
//  MoviesViewModel.swift
//  MobileChallenge-iOS
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import RxSwift
import RxRelay
import RxCocoa
import Networking
import Models

class MoviesViewModel: MoviesViewModelType, MoviesViewModelInput, MoviesViewModelOutput {

    var moviesRequest: PublishSubject<Void>
    var nextMoviesRequest: PublishSubject<Void>
    
    var element: BehaviorRelay<Response<[Movie]>?>
    var isLoading: Driver<Bool>
    var moreLoading: Driver<Bool>
    
    var inputs: MoviesViewModelInput { return self }
    var outputs: MoviesViewModelOutput { return self }
    
    private var page: Int = 1
    private var keyword: String = ""
    private let movieRequest = MovieRequest()
    private let disposeBag = DisposeBag()
    
    init() {
        moviesRequest = PublishSubject<Void>()
        nextMoviesRequest = PublishSubject<Void>()
        
        element = BehaviorRelay<Response<[Movie]>?>.init(value: nil)
        
        let movieLoading = ActivityIndicator()
        isLoading = movieLoading.asDriver()
        
        let nextMovieLoading = ActivityIndicator()
        moreLoading = nextMovieLoading.asDriver()
        
        let movieRequest = isLoading.asObservable()
            .sample(self.moviesRequest)
            .flatMap { isLoading -> Observable<Response<[Movie]>> in
                if isLoading { return Observable.empty() }
                self.page = 1
                return self.movieRequest.getMovies(keyword: self.keyword, page: self.page)
                    .trackActivity(movieLoading)
            }
        let nextMovieRequest = moreLoading.asObservable()
            .sample(self.nextMoviesRequest)
            .flatMap { isLoading -> Observable<Response<[Movie]>> in
                if isLoading { return Observable.empty() }
                if !self.isLoadMore() { return Observable.empty() }
                self.page = self.page + 1
                return self.movieRequest.getMovies(keyword: self.keyword, page: self.page).trackActivity(nextMovieLoading)
            }
        
        let request = Observable.of(movieRequest, nextMovieRequest)
            .merge()
            .share(replay: 1)
        
        Observable
            .combineLatest(request, element.asObservable()) { request, elements in
                if self.page == 1 {
                    return request
                } else {
                    var result = request
                    if let elementsItems = elements?.search {
                        result.search = elementsItems + (request.search ?? [])
                    }
                    return result
                }
            }
            .sample(request)
            .bind(to: element)
            .disposed(by: disposeBag)
    }
    
    func getMovie(with keyword: String) {
        self.keyword = keyword
        inputs.moviesRequest.onNext(())
    }

    private func isLoadMore() -> Bool {
        guard let numberOfItems = element.value?.search?.count,
              let totalResults = element.value?.totalResults,
              let totalItems = Int(totalResults) else { return false }
        return numberOfItems < totalItems
    }
    
}
