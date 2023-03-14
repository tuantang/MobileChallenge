//
//  UICollectionView+Common.swift
//  Utils
//
//  Created by Tuấn Tăng on 14/03/2023.
//

import UIKit

extension UICollectionView {
    public func registerWith<T: UICollectionViewCell>(cell typeTProductsReusableView: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.nameOfClass)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.nameOfClass, for: indexPath) as? T else {
            fatalError("Your \(T.nameOfClass) can not be found")
        }
        return cell
    }
}
