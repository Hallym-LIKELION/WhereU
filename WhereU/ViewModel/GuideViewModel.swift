//
//  GuideViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/08.
//

import Foundation

final class GuideViewModel {
    
    
    var selected: DisasterCategory = .heatWave
    
    func changedSelect(index: Int) {
        self.selected = DisasterCategory.categories[index]
    }
    
}
