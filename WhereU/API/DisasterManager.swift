//
//  DisasterManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/10.
//

import Foundation

class DisasterManager {
    
    static let shared = DisasterManager()
    
    private init() {}
    
    func fetchDisasters(categoryIndex: Int, completion: @escaping (Disaster) -> Void) {
        let urlString = "\(Constants.BASE_URL)api/weather/\(categoryIndex)"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(#function, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print(#function, "data is nil")
                return
            }
            
            do {
                let disaster = try JSONDecoder().decode(Disaster.self, from: data)
                completion(disaster)
            } catch {
                print(#function, error.localizedDescription)
            }
        }.resume()
    }
    
}
