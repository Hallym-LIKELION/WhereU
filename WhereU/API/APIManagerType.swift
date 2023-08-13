//
//  APIManagerType.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/11.
//

import Foundation

protocol APIManagerType {
    func fetch<T: Decodable>(url: String, completion: @escaping (Result<T, APIError>) -> Void)
}

extension APIManagerType {
    func fetch<T: Decodable>(url: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        completion(.failure(.networkError))
                    case .timedOut:
                        completion(.failure(.timeout))
                    default:
                        completion(.failure(.unknown))
                    }
                } else {
                    completion(.failure(.unknown))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
}
