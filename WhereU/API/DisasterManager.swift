//
//  DisasterManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/10.
//

import Foundation




class DisasterManager: APIManagerType {
    
    static let shared = DisasterManager()
    
    private init() {}
    
    func fetchDisasters(categoryIndex: Int, completion: @escaping (Result<Disaster,APIError>) -> Void) {
        let urlString = "\(Constants.BASE_URL)api/weather/\(categoryIndex)"
        print(urlString)
        fetch(url: urlString) { (result: Result<DisasterResponse, APIError>) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
