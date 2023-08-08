//
//  CategoryViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//
import UIKit

enum DisasterCategory: String {
    case heatWave = "폭염"
    case heavyRain = "태풍 ・ 호우"
    case coldWave = "한파"
    case dust = "황사"
    case landSlide = "산사태"
    
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
}

final class CategoryViewModel {
    
    let categories: [DisasterCategory] = [.heatWave, .heavyRain, .coldWave, .dust, .landSlide]
    let categoryIndex: Int
    let category: DisasterCategory
    
    init(categoryIndex: Int) {
        self.categoryIndex = categoryIndex
        self.category = categories[categoryIndex]
    }
    
    var icon: UIImage? {
        return category.image
    }
    
    var title: String {
        return category.rawValue
    }
}
