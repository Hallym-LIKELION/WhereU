//
//  HospitalManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import Foundation

class HospitalManager: APIManagerType {
    
    static let shared = HospitalManager()
    
    private init() { }
    
    func fetchArround(lat: Double, lon: Double, completion: @escaping(Result<[Hospital], APIError>) -> Void) {
        let urlString = "\(Constants.BASE_URL)api/hospital?lat=\(lat)&lon=\(lon)"
        
        fetch(url: urlString) { (result: Result<[Hospital], APIError>) in
            completion(result)
        }
        
    }
    
    func search(for keyword: String, completion: @escaping(Result<[Hospital], APIError>) -> Void) {
        let urlString = "\(Constants.BASE_URL)api/hospital/search?keyword=\(keyword)"
        guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        print(encodedStr)
        fetch(url: encodedStr) { result in
            completion(result)
        }
        
    }
    
}
