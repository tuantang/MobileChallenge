//
//  LoadMoreAble.swift
//  Utils
//
//  Created by Tuấn Tăng on 14/03/2023.
//

import UIKit
import RxSwift
import RxCocoa

public protocol LoadMoreAbleDelegate: NSObject {
    func triggerLoading(view: LoadMoreAble)
    func didAttach(view: LoadMoreAble)
    func didDetach(view: LoadMoreAble)
}

public extension LoadMoreAbleDelegate {
    func triggerLoading(view: LoadMoreAble) {}
    func didAttach(view: LoadMoreAble) {}
    func didDetach(view: LoadMoreAble) {}
}

public protocol LoadMoreAble: NSObject {
    var delegate: LoadMoreAbleDelegate? { get set }
    var isLoading: Bool { get set }
    var scrollView: UIScrollView? { get set }
    var bag: DisposeBag { get set }
    var indicator: UIActivityIndicatorView { get set }
    var originalContentInset: UIEdgeInsets { get set }
    var isEnabled: Bool { get set }
    
    func attach(to scrollView: UIScrollView)
    func detach()
    func endLoading()
}

extension LoadMoreAble {
    public func attach(to scrollView: UIScrollView) {
        guard self.scrollView == nil else { return }
        self.scrollView = scrollView
        scrollView
            .rx
            .contentOffset
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (offset) in
                guard let self = self else { return }
                guard self.isEnabled else {
                    scrollView.contentInset = self.originalContentInset
                    return
                }

                let frame = scrollView.frame
                let contentHeight = scrollView.contentSize.height
                guard contentHeight > frame.height else { return }
                if self.indicator.superview == nil {
                    self.originalContentInset = scrollView.contentInset
                }

                var contentInset = scrollView.contentInset
                let indicatorHeight: CGFloat = 30
                contentInset.bottom = self.originalContentInset.bottom + indicatorHeight + 10
                scrollView.contentInset = contentInset
                scrollView.addSubview(self.indicator)
                self.indicator.center = CGPoint(x: frame.width / 2, y: contentHeight + indicatorHeight - self.indicator.frame.height / 2)

                let triggerHeight = frame.height * 0.1
                if !self.isLoading, offset.y > contentHeight - triggerHeight - frame.height {
                    self.isLoading = true
                    self.indicator.startAnimating()
                    self.delegate?.triggerLoading(view: self)
                }
                self.delegate?.didAttach(view: self)
            }).disposed(by: bag)
    }
    
    public func detach() {
        self.scrollView?.contentInset = self.originalContentInset
        self.indicator.removeFromSuperview()
        
        self.delegate?.didDetach(view: self)
        
        self.scrollView = nil
        self.bag = DisposeBag()
    }
    
    public func endLoading() {
        self.isLoading = false
        self.indicator.stopAnimating()
        self.scrollView?.contentInset = self.originalContentInset
    }
}
