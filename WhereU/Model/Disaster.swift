//
//  Disaster.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/10.
//

import Foundation
import Foundation
import UIKit

// MARK: - DisasterElement
struct DisasterElement: Codable {
    let warnVar, warnStress: Int
    let areaName: String
    let lat, lon: Double
    
    var disasterName: String? {
        return DisasterCategory(rawValue: warnVar)?.name
    }
}

typealias Disaster = [DisasterElement]

enum DisasterCategory: Int {
    case all = 0
    case strongWind = 1 // 강풍
    case heavyRain = 2 // 호우
    case coldWave = 3 // 한파
    case dry = 4 // 건조
    case storm = 5 // 해일
    case wind = 6 // 풍랑
    case typhoon = 7 // 태풍
    case snowstorm = 8 // 대설
    case dust = 9 // 황사
    case heatWave = 12 // 폭염
    
    var icon: UIImage? {
        switch self {
        case .all:
            return UIImage(systemName: "globe.asia.australia")
        case .strongWind, .wind:
            return UIImage(systemName: "wind")
        case .heavyRain:
            return UIImage(named: "icon_wave")
        case .coldWave:
            return UIImage(named: "icon_snow")
        case .dry:
            return UIImage(systemName: "humidity")
        case .storm:
            return UIImage(systemName: "water.waves.and.arrow.up")
        case.typhoon:
            return UIImage(systemName: "tornado")
        case .dust:
            return UIImage(named: "icon_wind")
        case .heatWave:
            return UIImage(named: "icon_fire")
        default:
            return UIImage(named: "icon_mountain")
        }
    }
    
    var image: UIImage? {
        switch self {
        case .strongWind:
            return UIImage(named: "bg_rain")
        case .heavyRain:
            return UIImage(named: "bg_rain")
        case .coldWave:
            return UIImage(named: "bg_cold")
        case .dry:
            return UIImage(named: "bg_bad_air")
        case .storm:
            return UIImage(named: "bg_rain")
        case .wind:
            return UIImage(named: "bg_rain")
        case .typhoon:
            return UIImage(named: "bg_rain")
        case .snowstorm:
            return UIImage(named: "bg_cold")
        case .dust:
            return UIImage(named: "bg_bad_air")
        case .heatWave:
            return UIImage(named: "bg_fire")
        default:
            return UIImage(named: "bg_bad_air")
        }
    }
    
    var name: String {
        switch self {
        case .all:
            return "전체"
        case .strongWind:
            return "강풍"
        case .heavyRain:
            return "호우"
        case .coldWave:
            return "한파"
        case .dry:
            return "건조"
        case .storm:
            return "해일"
        case .wind:
            return "풍랑"
        case .typhoon:
            return "태풍"
        case .snowstorm:
            return "대설"
        case .dust:
            return "황사"
        case .heatWave:
            return "폭염"
        }
    }
    
    static var categories: [DisasterCategory] {
        [.all, .strongWind, .heavyRain, .coldWave, .dry, .storm, .wind, .typhoon, .snowstorm, .dust, .heatWave]
    }
}
