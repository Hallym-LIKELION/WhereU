//
//  APIError.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/11.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError
    case timeout
    case emptyData
    case decodeError
    case unknown
}
