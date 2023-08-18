//
//  HospitalManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import Foundation

class HospitalManager: APIManagerType {
    
    func fetchArround(lat: Double, lon: Double, completion: @escaping(Result<[Hospital], APIError>) -> Void) {
        let urlString = "\(Constants.BASE_URL)api/hospital?lat=\(lat)&long=\(lon)"
        
        fetch(url: urlString) { (result: Result<[Hospital], APIError>) in
            completion(result)
        }
        
    }
    
}
