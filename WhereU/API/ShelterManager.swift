//
//  ShelterManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import Foundation

class ShelterManager: APIManagerType {
    
    static let shared = ShelterManager()
    
    private init() {  }
    
    func fetchArround(lat: Double, lon: Double, completion: @escaping (Result<[Shelter], APIError>) -> Void) {
        let urlString = "\(Constants.BASE_URL)api/shelter?lat=\(lat)&lon=\(lon)"
        
        fetch(url: urlString) { (result: Result<[Shelter], APIError>) in
            completion(result)
        }
        
    }
    
    func fetchTest() -> [Shelter] {
        return [
            Shelter(areaName: "서울어린이대공원 대피소", lat: 37.55066333650905, lon: 127.06322591068566 ),
            Shelter(areaName: "서울 중구 예장동 대피소", lat: 37.55154503422879, lon: 126.99333443672381 ),
            Shelter(areaName: "서울 성북구 안암동 대피소", lat: 37.595078524718645, lon: 127.02557941397556 ),
        ]
    }
    
}
