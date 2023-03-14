//
//  LoadMoreViewProxy.swift
//  Utils
//
//  Created by Tuấn Tăng on 14/03/2023.
//

import RxSwift
import RxCocoa

class LoadMoreViewProxy: DelegateProxy<LoadMoreView, LoadMoreAbleDelegate>, LoadMoreAbleDelegate, DelegateProxyType {
    internal lazy var didTriggerLoading = PublishSubject<Void>()
    
    static func registerKnownImplementations() {
        self.register { LoadMoreViewProxy(loadMoreView: $0) }
    }
    
    static func currentDelegate(for object: LoadMoreView) -> LoadMoreAbleDelegate? {
        let loadMoreView: LoadMoreView = castOrFatalError(object)
        return loadMoreView.delegate
    }
    
    static func setCurrentDelegate(_ delegate: LoadMoreAbleDelegate?, to object: LoadMoreView) {
        let loadMoreView: LoadMoreView = castOrFatalError(object)
        loadMoreView.delegate = castOptionalOrFatalError(delegate)
    }
    
    init(loadMoreView: LoadMoreView) {
           super.init(parentObject: loadMoreView, delegateProxy: LoadMoreViewProxy.self)
    }
    
    func triggerLoading(view: LoadMoreAble) {
        if let delegate = _forwardToDelegate as? LoadMoreAbleDelegate {
            delegate.triggerLoading(view: view)
        }
        didTriggerLoading.onNext(())
    }
}

func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        fatalError("Failure converting from \(String(describing: value)) to \(T.self)")
    }
    
    return result
}

func castOptionalOrFatalError<T>(_ value: Any?) -> T? {
    if value == nil {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}
