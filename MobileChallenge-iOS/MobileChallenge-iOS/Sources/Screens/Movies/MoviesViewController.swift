//
//  MoviesViewController.swift
//  MobileChallenge-iOS
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Models
import Utils

class MoviesViewController: BaseViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    lazy var searchBar = UISearchBar(frame: .zero)
    
    private let loadMoreView = LoadMoreView()
    private let refreshControl = UIRefreshControl()
    
    private let viewModel: MoviesViewModel
    private let disposeBag = DisposeBag()
    private let spacing: CGFloat = 16
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustUI()
        configureCollectionView()
        bind(to: viewModel)
    }
    
    private func adjustUI() {
        navigationItem.title = "Film List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white
        
        searchBar.placeholder = "Search"

        navigationItem.titleView = searchBar
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.registerWith(cell: MovieViewCell.self)
        collectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    private func bind(to viewModel: MoviesViewModel) {        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Movie>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(MovieViewCell.self, for: indexPath)
                cell.configure(with: item)
                return cell
            }
        )
        
        viewModel
            .outputs
            .element
            .do(afterNext: { [weak self, weak loadMoreView] result in
                guard let self = self else { return }
                loadMoreView?.endLoading()
                if let items = result?.search, let totalResults = result?.totalResults, let total = Int(totalResults), items.count < total {
                        loadMoreView?.attach(to: self.collectionView)
                } else {
                    loadMoreView?.detach()
                }
            }).flatMap({ element -> BehaviorRelay<[Movie]> in
                return BehaviorRelay<[Movie]>.init(value: element?.search ?? [])
            })
            .asDriver(onErrorJustReturn: [])
            .map { [AnimatableSectionModel(model: "Movie", items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        loadMoreView.rx
            .didTriggerLoading
            .bind(to: viewModel.inputs.nextMoviesRequest)
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { [weak self] keyword in
                guard let self = self else { return }
                self.viewModel.getMovie(with: keyword ?? "")
            }).disposed(by: disposeBag)
        
        viewModel
            .outputs
            .element
            .asObservable()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
    }
    
    @objc private func pullToRefresh() {
        viewModel.inputs.moviesRequest.onNext(())
    }
}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - spacing * 3) / 2
        return CGSize(width: width, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
}
