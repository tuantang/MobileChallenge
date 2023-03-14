//
//  LoadMoreView.swift
//  Utils
//
//  Created by Tuấn Tăng on 14/03/2023.
//

import UIKit
import RxSwift
import RxCocoa

public class LoadMoreView: NSObject, LoadMoreAble {
    weak public var delegate: LoadMoreAbleDelegate? = nil
    weak public var scrollView: UIScrollView? = nil
    
    public var isLoading: Bool = false
    public var bag: DisposeBag = DisposeBag()
    public var indicator: UIActivityIndicatorView
    public var originalContentInset: UIEdgeInsets = .zero
    public var isEnabled: Bool = true
    
    override public init() {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        self.indicator = indicator
        super.init()
    }
}

extension Reactive where Base: LoadMoreView {
    var delegate: DelegateProxy<LoadMoreView, LoadMoreAbleDelegate> {
        return LoadMoreViewProxy.proxy(for: base)
    }
    
    public var didTriggerLoading: Observable<Void> {
        return LoadMoreViewProxy.proxy(for: base)
            .didTriggerLoading.asObservable()
    }
}
