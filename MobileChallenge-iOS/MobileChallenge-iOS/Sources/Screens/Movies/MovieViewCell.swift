//
//  MovieViewCell.swift
//  MobileChallenge-iOS
//
//  Created by Tuấn Tăng on 14/03/2023.
//

import UIKit
import SnapKit
import SDWebImage
import Models

class MovieViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    func configure(with movie: Movie) {
        imageView.sd_setImage(with: URL(string: movie.poster), placeholderImage: UIImage(named: "no-image"))
        titleLabel.text = movie.title
    }
    
}

extension MovieViewCell {
    private func adjustUI() {
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let titleView: UIView = {
            let view = UIView()
            view.addSubview(titleLabel)
            return view
        }()
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [imageView, titleView])
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .fill
            return stackView
        }()
        
        addSubview(stackView)
        
        titleView.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
            make.left.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.top).offset(10)
            make.left.equalTo(titleView.snp.left).offset(10)
            make.right.equalTo(titleView.snp.right).offset(-10)
        }

    }
}
