//
//  WeatherManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/05.
//

import Foundation

class WeatherManager {
    
    static let shared = WeatherManager()
    
    private init() {}
    
    func fetchWeater(x: Int, y: Int, completion: @escaping ([Item]) -> Void) {
        let requestURLString = "\(Constants.WEATHER_BASE_URL)&base_date=\("20230805")&base_time=\("1400")&nx=\(x)&ny=\(y)"
        
        guard let requestURL = URL(string: requestURLString) else {
            print("잘못된 url")
            return
        }
        let request = URLRequest(url: requestURL)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let safeData = data else { return }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: safeData)
                
                let items = weatherResponse.response.body.items.item
                    .filter {
                        $0.category == .tmp || $0.category == .sky ||
                        $0.category == .tmx || $0.category == .tmn
                    }
                
                completion(items)
                
            } catch {
                print("decode error")
            }
        }.resume()
        
    }
}
