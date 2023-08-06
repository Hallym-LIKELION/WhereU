//
//  WeatherForTimeViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/06.
//

import UIKit

class WeatherForTimeViewModel {
    
    let data: WeatherForTime
    
    init(data: WeatherForTime) {
        self.data = data
    }
    
    var time: String {
        data.time
    }
    
    var weatherImage: UIImage? {
        data.image
    }
    
    var temperature: String {
        data.temperature
    }
    
}
