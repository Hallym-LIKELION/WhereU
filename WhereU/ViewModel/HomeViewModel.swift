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
        LocationManager.shared.reverseGeoCodeLocation { [weak self] address in
            let local = address.split(separator: " ").map{ String($0) }[1]
            self?.currentLocation = address
            // 현재 위치로부터 x,y 격자값 가져오기
            OpenXlsx.shared.getXYFromAddress(local) { x, y in
                guard let x = x, let y = y else { return }
                // 기상청 API 사용해서 격자값으로 날씨 가져오기
                WeatherManager.shared.fetchWeater(x: x, y: y) { [weak self] items in
                    self?.weatherItems = items
                }
            }
        }
    }
    
    var name: String {
        return user.name
    }
    
    var weatherImage: UIImage? {
        guard let skyData = weatherItems.filter({ $0.category == .sky }).first else { return nil }
        
        if Int(skyData.fcstTime)! >= 2000 || Int(skyData.fcstTime)! <= 600 { // 밤
            switch Int(skyData.fcstValue)! {
            case 1: //맑음
                return UIImage(named: "sunny_night")
            case 3: //구름많음
                return UIImage(named: "cloudy_night")
            case 4: //흐림
                return UIImage(named: "cloudy_2")
            default:
                return nil
            }
        } else { // 낮
            switch Int(skyData.fcstValue)! {
            case 1: //맑음
                return UIImage(named: "sunny")
            case 3: //구름많음
                return UIImage(named: "cloudy_1")
            case 4: //흐림
                return UIImage(named: "cloudy_2")
            default:
                return nil
            }
        }
        
    }
    
}
