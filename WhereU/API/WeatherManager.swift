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
        var date = "yyyyMMdd".stringFromDate()
        let time = Int("HH00".stringFromDate())!
        if time < 200 { // 현재 시간이 오전 2시 이전이면
            date = String(Int(date)!-1) // 하루 전날을 기준으로 요청
        }
        let baseTime = getBaseTime()
        
        let requestURLString = "\(Constants.WEATHER_BASE_URL)&base_date=\(date)&base_time=\(baseTime)&nx=\(x)&ny=\(y)"
        
        
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
                        $0.category == .tmx || $0.category == .tmn ||
                        $0.category == .pty || $0.category == .pop
                    }
                
                completion(items)
                
            } catch {
                print(error.localizedDescription)
                print("decode error")
            }
        }.resume()
        
    }
    func getBaseTime() -> String {
        // API에서는 정해진 시간에 맞춰서 기상 예보를 업데이트 함. 단기 예보의 경우 오전 2시부터 3시간 간격으로 업데이트
        // 따라서 현재 시간을 기준으로 가장 최근의 업데이트 시간을 얻어야함.
        let baseTime = [200, 500, 800, 1100, 1400, 1700, 2000, 2300]
        var time = Int("HH00".stringFromDate())!
        
        if let timeIdx = baseTime.firstIndex(of: time) {
            return String(format: "%04d", baseTime[timeIdx])
        } else {
            while !baseTime.contains(time) {
                if time == 0 {
                    time = 2300
                } else {
                    time -= 100
                }
            }
            
            let timeIdx = baseTime.firstIndex(of: time)!
            return String(format: "%04d", baseTime[timeIdx])
        }
    }
}
