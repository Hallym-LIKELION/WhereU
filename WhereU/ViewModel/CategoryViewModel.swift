//
//  CategoryViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//
import UIKit

final class CategoryViewModel {
    
    let category: DisasterCategory
    
    init(categoryIndex: Int) {
        self.category = DisasterCategory.categories[categoryIndex]
    }
    
    var icon: UIImage? {
        return category.image
    }
    
    var title: String {
        return category.name
    }
}
