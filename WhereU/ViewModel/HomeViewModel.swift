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
            weatherObserver()
        }
    }
    var weatherObserver: ()->Void = {}
    
    var currentLocation: String = "" {
        didSet {
            locationObserver(currentLocation)
        }
    }

    var locationObserver: (String) -> Void = { _ in }
    
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
    
    func fetchWeather(x: Int, y: Int) {
        // 기상청 API 사용해서 격자값으로 날씨 가져오기
        WeatherManager.shared.fetchWeater(x: x, y: y) { [weak self] items in
            self?.weatherItems = items
        }
    }
    
}
