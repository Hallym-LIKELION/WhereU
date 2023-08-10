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
    case strongWind = 1 // 강풍
    case heavyRain = 2 // 호우
    case coldWave = 3 // 한파
    case dry = 4 // 건조
    case storm = 5 // 폭풍 해일
    case wind = 6 // 풍랑
    case typhoon = 7 // 태풍
    case snowstorm = 8 // 대설
    case dust = 9 // 황사
    case heatWave = 12 // 폭염
    
    var image: UIImage? {
        switch self {
        case .heatWave:
            return UIImage(named: "icon_fire")
        case .heavyRain:
            return UIImage(named: "icon_wave")
        case .coldWave:
            return UIImage(named: "icon_snow")
        case .dust:
            return UIImage(named: "icon_wind")
        default:
            return UIImage(named: "icon_mountain")
        }
    }
    
    var name: String {
        switch self {
        case .strongWind:
            return "강풍"
        case .heavyRain:
            return "호우"
        case .coldWave:
            return "한파"
        case .dry:
            return "건조"
        case .storm:
            return "폭풍해일"
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
        [.strongWind, .heavyRain, .coldWave, .dry, .storm, .wind, .typhoon, .snowstorm, .dust, .heatWave]
    }
}
