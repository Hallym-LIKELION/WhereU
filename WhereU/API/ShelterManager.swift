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
            Shelter(areaName: "서울특별시 중구 다산로 32 (신당동, 남산타운)", lat: 37.54901359, lon: 127.0092804 ),
            Shelter(areaName: "서울특별시 중구 다산로 지하 115 (신당동, 약수역 6호선)", lat: 37.55476349, lon: 127.0104958 ),
            Shelter(areaName: "서울특별시 중구 장충단로 60 (장충동2가, 반얀트리 클럽 앤 스파 서울)", lat: 37.55026344, lon: 127.0005364 ),
            Shelter(areaName: "서울특별시 중구 동호로10길 30 (신당동, 약수하이츠)", lat: 37.55476842, lon: 127.01471 ),
            Shelter(areaName: "서울특별시 중구 다산로 32 (신당동, 남산타운)", lat: 37.54901359, lon: 127.0092804 ),
            Shelter(areaName: "서울특별시 중구 동호로5길 19 (신당동, 중구청소년수련관)", lat: 37.5518396, lon: 127.0125841 ),
            Shelter(areaName: "서울특별시 중구 다산로 32 (신당동, 남산타운)", lat: 37.54901359, lon: 127.0092804 ),
            Shelter(areaName: "서울특별시 중구 다산로 지하122, 약수역 3호선 (신당동)", lat: 37.55444767, lon: 127.0109906 ),
            Shelter(areaName: "서울특별시 중구 동호로 191 (신당동, 선일빌딩)", lat: 37.55505322, lon: 127.0100685 ),
            Shelter(areaName: "서울특별시 중구 다산로 지하 38 (신당동, 버티고개역 6호선)", lat: 37.54818732, lon: 127.0070664 ),
            Shelter(areaName: "서울특별시 용산구 서빙고로 137 (용산동6가, 국립중앙박물관)", lat: 37.52303715, lon: 126.9822349 ),
            
        ]
    }
    
}
