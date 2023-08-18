//
//  HospitalViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import Foundation

class HospitalViewModel {
    
    var address: String = "" {
        didSet {
            addressObserver(address)
        }
    }
    var addressObserver: (String) -> Void = { _ in }
    
    init() {
        
        LocationManager.shared.reverseGeoCodeLocation { [weak self] address, _ in
            guard let self = self else { return }

            self.address = address
        }
    }
    
    
    
}
