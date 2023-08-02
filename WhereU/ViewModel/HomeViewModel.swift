//
//  HomeViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/02.
//

import Foundation

final class HomeViewModel {
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var name: String {
        return user.name
    }
    
    
    
}
