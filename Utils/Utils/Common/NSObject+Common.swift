//
//  NSObject+Common.swift
//  Utils
//
//  Created by Tuấn Tăng on 14/03/2023.
//

import Foundation

extension NSObject {
    public static var nameOfClass: String {
        return String(describing: self)
    }
    
    func nameOfClass() -> String {
        return "\(type(of: self))"
    }
}
