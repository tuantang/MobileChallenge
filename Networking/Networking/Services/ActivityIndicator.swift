//
//  ActivityIndicator.swift
//  Networking
//
//  Created by Tuấn Tăng on 14/03/2023.
//

import RxSwift
import RxCocoa

private struct ActivityToken<E>: ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable
    
    init(source: Observable<E>, disposeAction: @escaping () -> ()) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}

public class ActivityIndicator : SharedSequenceConvertibleType {
    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let lock = NSRecursiveLock()
    private let behaviorRelay = BehaviorRelay(value: 0)
    private let loading: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        loading = behaviorRelay.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return Observable.using({ () -> ActivityToken<O.Element> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }
    
    private func increment() {
        lock.lock()
        behaviorRelay.accept(behaviorRelay.value + 1)
        lock.unlock()
    }
    
    private func decrement() {
        lock.lock()
        behaviorRelay.accept(behaviorRelay.value - 1)
        lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return loading
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
