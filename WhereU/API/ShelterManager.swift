//
//  ShelterManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import Foundation

class ShelterManager: APIManagerType {
    
    func fetchArround(lat: Double, lon: Double, completion: @escaping (Result<[Shelter], APIError>) -> Void) {
        let urlString = "\(Constants.BASE_URL)api/shelter?lat=\(lat)&lon=\(lon)"
        
        fetch(url: urlString) { (result: Result<[Shelter], APIError>) in
            completion(result)
        }
        
    }
    
}
