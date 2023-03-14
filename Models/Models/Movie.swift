//
//  Movie.swift
//  Models
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import Foundation
import RxDataSources

public struct Movie: Codable {
    let id: String = UUID().uuidString
    public let title, year, imdbID, type, poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
        case imdbID
    }
}

extension Movie: Equatable {
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Movie: IdentifiableType {
    public typealias Identity = String
    public var identity: String {
        return id
    }
}
