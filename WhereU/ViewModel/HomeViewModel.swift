//
//  HomeViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/02.
//

import UIKit

final class HomeViewModel {
    
    let user: User
    var weatherItems: [Item] = [] {
        didSet {
            weatherObservers.forEach { task in
                task()
            }
        }
    }
    var weatherObservers: [()->Void] = []
    func appendWeatherObserver(_ task: @escaping () -> Void) {
        weatherObservers.append(task)
    }
    
    var currentLocation: String = "" {
        didSet {
            locationObservers.forEach { task in
                task(currentLocation)
            }
        }
    }
    var locationObservers: [(String) -> Void] = []
    func appendLocationObserver(_ task: @escaping (String) -> Void) {
        locationObservers.append(task)
    }
    
    init(user: User) {
        self.user = user
        
        // 현재 위치 가져오기
        LocationManager.shared.reverseGeoCodeLocation { [weak self] address, pos in
            self?.currentLocation = address
            // 현재 위치로부터 x,y 격자값 가져오기
            let (x,y) = pos
            self?.fetchWeather(x: x, y: y)
        }
    }
    
    var name: String {
        return user.name
    }
    
    var weatherImage: (UIImage?,UIImage?)? {
        guard let skyType = weatherItems.filter({ $0.category == .sky }).first else { return nil }
        guard let rainType = weatherItems.filter({ $0.category == .pty }).first else { return nil }
        
        if Int(skyType.fcstTime)! >= 2000 || Int(skyType.fcstTime)! <= 600 { // 밤
            switch Int(skyType.fcstValue)! {
            case 1: //맑음
                return (UIImage(named: "sunny_night"), UIImage(named: "bg_sunny_night"))
            case 3,4: //구름많음
                switch Int(rainType.fcstValue)! {
                case 0: // 비 안옴
                    return (UIImage(named: "cloudy_night"), UIImage(named: "bg_cloudy_night"))
                case 1,2,4: // 비
                    return (UIImage(named: "rainy_2"), UIImage(named: "bg_rainy_night"))
                default: // 눈
                    return (UIImage(named: "snow"), UIImage(named: "bg_cloudy_night"))
                }
            default:
                return nil
            }
        } else { // 낮
            switch Int(skyType.fcstValue)! {
            case 1: //맑음
                return (UIImage(named: "sunny"), UIImage(named: "bg_sunny"))
            case 3: //구름많음
                switch Int(rainType.fcstValue)! {
                case 0: // 비 안옴
                    return (UIImage(named: "cloudy_1"), UIImage(named: "bg_cloudy"))
                case 1,2,4: // 비
                    return (UIImage(named: "rainy_1"), UIImage(named: "bg_rainy"))
                default: // 눈
                    return (UIImage(named: "snow"), UIImage(named: "bg_cloudy"))
                }
            case 4: //흐림
                switch Int(rainType.fcstValue)! {
                case 0: // 비 안옴
                    return (UIImage(named: "cloudy_2"), UIImage(named: "bg_cloudy"))
                case 1,2,4: // 비
                    return (UIImage(named: "rainy_2"), UIImage(named: "bg_rainy"))
                default: // 눈
                    return (UIImage(named: "snow"), UIImage(named: "bg_cloudy"))
                }
            default:
                return nil
            }
        }
    }
    
    var adviceText: String? {
        let rainRate = weatherItems.filter{ $0.category == .pop }
        
        var isRainy = false
        rainRate.forEach { item in
            if Int(item.fcstValue)! > 0 {
                isRainy = true
            }
        }
        
        return isRainy ? "오늘은 우산을 챙겨나가세요" : "오늘은 비 예보가 없습니다."
    }
    
    var isNight: Bool {
        let currentHour = Int("HH".stringFromDate())!
        return currentHour >= 18 || currentHour <= 6 ? true : false
    }
    
    var adviceTextColor: UIColor? {
        return isNight ? .white : .black
    }
    
    var upTimeText: String {
        let time = WeatherManager.shared.getBaseTime()
        let pmAm = time >= "1200" ? "PM" : "AM"
        var timeArray = time.map{ String($0) }
        timeArray.insert(":", at: 2)
        
        return "\(timeArray.joined(separator: "")) \(pmAm) 업데이트 됨"
    }
    
    var currentTemperature: String {
        if weatherItems.isEmpty { return "" }
        
        let temp = weatherItems.filter { $0.category == .tmp }[0]
        return "\(temp.fcstValue)°"
    }
    
    func fetchWeather(x: Int, y: Int) {
        // 기상청 API 사용해서 격자값으로 날씨 가져오기
        WeatherManager.shared.fetchWeater(x: x, y: y) { [weak self] result in
            switch result {
            case .success(let items):
                self?.weatherItems = items
            case .failure(let error):
                print(error.localizedDescription)
                self?.weatherItems = []
            }
        }
    }
    
    var weatherForTimeCount: Int {
        let temps = weatherItems.filter({ $0.category == .tmp })
        return temps.count
    }
    
    func getWeatherForTime(index: Int) -> WeatherForTime {
        let skyTypes = weatherItems.filter({ $0.category == .sky })[index]
        let rainTypes = weatherItems.filter({ $0.category == .pty })[index]
        let temps = weatherItems.filter({ $0.category == .tmp })[index]
        
        let start = temps.fcstTime.index(temps.fcstTime.startIndex, offsetBy: 0)
        let end = temps.fcstTime.index(temps.fcstTime.startIndex, offsetBy: 1)
        let time = String(temps.fcstTime[start...end])
        
        var image: UIImage?
        
        if time >= "20" || time <= "06" { // 밤
            switch Int(skyTypes.fcstValue)! {
            case 1: // 맑음
                image = UIImage(named: "sunny_night")
            default: // 구름 많음
                switch Int(rainTypes.fcstValue)! {
                case 0: // 비 안옴
                    image = UIImage(named: "cloudy_night")
                case 1,2,4 : // 비
                    image = UIImage(named: "rainy_2")
                default: // 눈
                    image = UIImage(named: "snow")
                }
            }
        } else { // 낮
            switch Int(skyTypes.fcstValue)! {
            case 1: // 맑음
                image = UIImage(named: "sunny")
            case 3: // 구름 많음
                switch Int(rainTypes.fcstValue)! {
                case 0: // 비 안옴
                    image = UIImage(named: "cloudy_1")
                case 1,2,4 : // 비
                    image = UIImage(named: "rainy_1")
                default: // 눈
                    image = UIImage(named: "snow")
                }
            default: // 흐림
                switch Int(rainTypes.fcstValue)! {
                case 0: // 비 안옴
                    image = UIImage(named: "cloudy_2")
                case 1,2,4 : // 비
                    image = UIImage(named: "rainy_2")
                default: // 눈
                    image = UIImage(named: "snow")
                }
            }
        }
        
        return WeatherForTime(time: "\(time)시", image: image, temperature: "\(temps.fcstValue)°")
    }
    
}
