//
//  GuideManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/11.
//

import Foundation

class GuideManager: APIManagerType {
    
    static let shared = GuideManager()
    
    private init() {}
    
    func fetchAll(completion: @escaping (Result<Guide, APIError>) -> Void) {
        let urlString = "\(Constants.BASE_URL)api/guide"
        
        fetch(url: urlString) { (result: Result<Guide, APIError>) in
            completion(result)
        }
    }
    
    func search(keyword: String, completion: @escaping (Result<Guide, APIError>) -> Void) {
        let urlString = "\(Constants.BASE_URL)api/guide/search?keyword=\(keyword)"
        
        fetch(url: urlString) { (result: Result<Guide, APIError>) in
            completion(result)
        }
    }
    
}
