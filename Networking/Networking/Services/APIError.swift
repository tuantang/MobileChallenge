//
//  APIError.swift
//  Networking
//
//  Created by Tuấn Tăng on 13/03/2023.
//

enum APIError: Error {
    case badRequest             // Status code 400
    case unauthorized           // Status code 401
    case forbidden              // Status code 403
    case notFound               // Status code 404
    case noAllowed              // Status code 405
    case conflict               // Status code 409
    case internalServerError    // status code 500
}
